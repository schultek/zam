import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
import { sha256 } from 'js-sha256';

process.env.GCLOUD_PROJECT = "jufa20";
admin.initializeApp();

const db = admin.firestore();
db.settings({timestampsInSnapshots: true});

const USER_ROLES = ["participant", "leader", "organizer"];

export const createEncodedLinkParams = functions.https.onCall(async (data, context) => {

  let isAdmin = context.auth.token.isAdmin || false;

  if ("tripId" in data) {

    if (typeof data.tripId !== "string") {
      throw new functions.https.HttpsError('failed-precondition', 'The tripId must be a string.');
    }
    if (!("role" in data)) {
      throw new functions.https.HttpsError('failed-precondition', 'You must specify a role for this link.');
    }
    if (typeof data.role !== "string") {
      throw new functions.https.HttpsError('failed-precondition', 'The role must be a string.');
    }
    if (!USER_ROLES.includes(data.role)) {
      throw new functions.https.HttpsError('failed-precondition', `Invalid role ${data.role}.`);
    }

    let trip = await db.collection("trips").doc(data.tripId).get();

    if (!trip.exists) {
      throw new functions.https.HttpsError('failed-precondition', `The trip with id ${data.tripId} does not exist.`);
    }

    if (!isAdmin && trip.get(`users.${context.auth.uid}.role`) !== "organizer") {
      throw new functions.https.HttpsError('failed-precondition', `You are not authorized to create this invitation link.`);
    }

    return encodeParameters({tripId: data.tripId, role: data.role});

  } else if ("claim" in data) {

    if (data.claim === "canCreateTrips") {

      if (!isAdmin) {
        throw new functions.https.HttpsError('failed-precondition', `You are not authorized to create a trip creator link.`);
      }

      return encodeParameters({claim: data.claim});

    } else if (data.claim === "isAdmin") {

      if (!isAdmin) {
        throw new functions.https.HttpsError('failed-precondition', `You are not authorized to create an admin link.`);
      }

      return encodeParameters({claim: data.claim});

    } else {
      throw new functions.https.HttpsError('failed-precondition', `Unknown claim ${data.claim}.`);
    }

  } else {
    throw new functions.https.HttpsError('failed-precondition', `Unallowed parameters ${JSON.stringify(data)}.`);
  }

})

const SECRET_KEY = "ilovejufa";

function getQuery(params) {
  return Object.entries(params).sort((a, b) => a[0] < b[0] ? 1 : -1).map(([k, v]) => k+"="+v).join("&");
}

function encodeParameters(params) {
  let query = getQuery(params);
  let hash = sha256.hmac(SECRET_KEY, query);
  return query+"&h="+hash;
}

export const receiveEncodedLinkParams = functions.https.onCall(async (data, context) => {

  let {h: receivedHash, ...params} = data;

  let query = getQuery(params);
  let calculatedHash = sha256.hmac(SECRET_KEY, query);

  if (receivedHash !== calculatedHash) {
    throw new functions.https.HttpsError('failed-precondition', `Invalid link hash.`);
  }

  if ("tripId" in data) {

    let trip = await db.collection("trips").doc(data.tripId).get();

    if (!trip.exists) {
      throw new functions.https.HttpsError('failed-precondition', `The trip with id ${data.tripId} does not exist.`);
    }

    const uid = context.auth.uid;
  
    console.log(`Adding user ${uid} to trip ${data.tripId} with role ${data.role}.`);
  
    await trip.ref.update('users.'+uid+'.role', data.role || "participant");
    return false;

  } else if ("claim" in data) {

    const uid = context.auth.uid;

    let canCreateTrips = context.auth.token.canCreateTrips || false;
    let isAdmin = context.auth.token.isAdmin || false;

    let claimsChanged = false;

    if (data.claim === "canCreateTrips" && !canCreateTrips) {
      canCreateTrips = true;
      claimsChanged = true;
    } else if (data.claim === "isAdmin" && !isAdmin) {
      isAdmin = true;
      canCreateTrips = true;
      claimsChanged = true;
    }

    if (claimsChanged) {
      console.log(`Setting permission of user ${uid} to 'canCreateTrips=${canCreateTrips} isAdmin=${isAdmin}'.`);

      await admin.auth().setCustomUserClaims(uid, {canCreateTrips, isAdmin});
      return true;

    } else {
      console.log("Unchanged claims for user "+uid+".");
      return false;
    }

  }

  throw new functions.https.HttpsError('failed-precondition', `Could not handle parameters ${JSON.stringify(params)}.`);

})