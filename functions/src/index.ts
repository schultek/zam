import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { sha256 } from 'js-sha256';
import {URL} from 'url';

admin.initializeApp();

const db = admin.firestore();
db.settings({timestampsInSnapshots: true});

const USER_ROLES = ["participant", "leader", "organizer"];
const SECRET_KEY = "ilovejufa";

export const createOrganizerLink = functions.https.onCall(async (data, context) => {

  let isAdmin = context.auth.token.isAdmin || false;

  if (!isAdmin) {
    throw new functions.https.HttpsError('failed-precondition', `You are not authorized to create an organizer link.`);
  }

  if (!("phoneNumber" in data)) {
    throw new functions.https.HttpsError('failed-precondition', 'Missing phoneNumber argument.');
  }


  return hashLink(`https://jufa20.web.app/invitation/organizer?phoneNumber=${encodeURIComponent(data.phoneNumber)}`);
});

export const createAdminLink = functions.https.onCall(async (data, context) => {

  let isAdmin = context.auth.token.isAdmin || false;

  if (!isAdmin) {
    throw new functions.https.HttpsError('failed-precondition', `You are not authorized to create an admin link.`);
  }

  if (!("phoneNumber" in data)) {
    throw new functions.https.HttpsError('failed-precondition', 'Missing phoneNumber argument.');
  }

  return hashLink(`https://jufa20.web.app/invitation/admin?phoneNumber=${encodeURIComponent(data.phoneNumber)}`);
});


export const createTripInvitationLink = functions.https.onCall(async (data, context) => {


  if (!("tripId" in data)) {
    throw new functions.https.HttpsError('failed-precondition', 'Missing tripId argument.');
  }

  if (!("role" in data)) {
    throw new functions.https.HttpsError('failed-precondition', 'Missing role argument.');
  }

  if (!USER_ROLES.includes(data.role)) {
    throw new functions.https.HttpsError('failed-precondition', `Invalid role ${data.role}.`);
  }

  let trip = await db.collection("trips").doc(data.tripId).get();

  if (!trip.exists) {
    throw new functions.https.HttpsError('failed-precondition', `The trip with id ${data.tripId} does not exist.`);
  }

  let isAdmin = context.auth.token.isAdmin || false;

  if (!isAdmin && trip.get(`users.${context.auth.uid}.role`) !== "organizer") {
    throw new functions.https.HttpsError('failed-precondition', `You are not authorized to create this invitation link.`);
  }

  return hashLink(`https://jufa20.web.app/invitation/trip?tripId=${data.tripId}&role=${data.role}`);
});

export const onLinkReceived = functions.https.onCall(async (data, context) => {

  if (context.auth == null) {
    throw new functions.https.HttpsError('failed-precondition', 'You need to be logged in.');
  }

  if (!("link" in data)) {
    throw new functions.https.HttpsError('failed-precondition', 'Missing link argument.');
  }

  var url = new URL(data.link);

  var hmac = url.searchParams.get('hmac');
  var link = data.link.substring(0, data.link.lastIndexOf('&hmac='));

  let calculatedHmac = sha256.hmac(SECRET_KEY, link);

  if (hmac !== calculatedHmac) {
    throw new functions.https.HttpsError('failed-precondition', `Invalid link hash.`);
  }

  if (url.pathname === '/invitation/organizer' || url.pathname === '/invitation/admin') {

    var user = await admin.auth().getUser(context.auth.uid);

    var phoneNumber = decodeURIComponent(url.searchParams.get('phoneNumber'));

    if (user.phoneNumber !== phoneNumber) {
      throw new functions.https.HttpsError('failed-precondition', `User's phone number (${user.phoneNumber}) does not match required number from invitation (${phoneNumber}).`);
    }

    if (url.pathname.endsWith('organizer')) {
      await admin.auth().setCustomUserClaims(context.auth.uid, {isOrganizer: true});
    } else if (url.pathname.endsWith('admin')) {
      await admin.auth().setCustomUserClaims(context.auth.uid, {isAdmin: true});
    }

    return true;

  } else if (url.pathname === '/invitation/trip') {

    var tripId = url.searchParams.get('tripId');
    var role = url.searchParams.get('role');

    let trip = await db.collection("trips").doc(tripId).get();

    if (!trip.exists) {
      throw new functions.https.HttpsError('failed-precondition', `The trip with id ${tripId} does not exist.`);
    }

    const uid = context.auth.uid;
  
    console.log(`Adding user ${uid} to trip ${tripId} with role ${role}.`);
  
    await trip.ref.update('users.'+uid+'.role', role || "participant");

  }

  return false;

});

export const sendAnnouncementNotification = functions.firestore.document("trips/{tripId}/modules/announcements/announcements/{announcementId}").onCreate(async (snapshot, context) => {

  var tripId = context.params.tripId;

  var data = snapshot.data();

  await admin.messaging().sendToTopic(`/topics/trip.${tripId}.announcements`, {
    notification: {
      title: data.title ?? "New announcement",
      body: data.message
    }
  });

});

export const sendChannelNotification = functions.firestore.document("trips/{tripId}/modules/chat/channels/{channelId}/messages/{messageId}").onCreate(async (snapshot, context) => {

  var tripId = context.params.tripId;
  var channelId = context.params.channelId;

  var trip = (await admin.firestore().doc(`trips/${tripId}`).get()).data();
  var channel = (await admin.firestore().doc(`trips/${tripId}/modules/chat/channels/${channelId}`).get()).data();

  var data = snapshot.data();

  var tokens = channel.members.filter((id) => id != data.sender).map((id) => trip.users[id]?.token).filter((t) => t != null);

  await admin.messaging().sendToDevice(tokens, {
    notification: {
      title: `${channel.name} - ${trip.users[data.sender]?.nickname ?? 'Anonym'}`,
      body: data.text,
      tag: `${tripId}_${channelId}`,
    },
    data: {
      tripId: tripId,
      channelId: channelId,
    }
  });
});

function hashLink(link) {
  let hash = sha256.hmac(SECRET_KEY, link);
  return link+"&hmac="+hash;
}