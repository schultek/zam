import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

const db = admin.firestore();
db.settings({timestampsInSnapshots: true});

export const updateUserPermissions = functions.https.onCall(async (data, context) => {

  if (!context.auth) {
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called while authenticated.');
  }
  if (data.canCreateTrips == null || typeof data.canCreateTrips != "boolean") {
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called with a valid permission key.');
  }

  const uid = context.auth.uid;

  console.log(`Setting permission of user ${uid} to 'canCreateTrips=${data.canCreateTrips}'.`);

  await admin.auth().setCustomUserClaims(uid, {canCreateTrips: data.canCreateTrips});
});

export const addUserToTrip = functions.https.onCall(async (data, context) => {

  if (!context.auth) {
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called while authenticated.');
  }
  if (!data.tripId) {
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called with a valid tripId.');
  }
  if (!data.userRole) {
    data.userRole = "participant";
  }

  const tripId = data.tripId;
  const userRole = data.userRole;
  const uid = context.auth.uid;

  let trip = await db.collection("trips").doc(tripId).get();

  if (!trip.exists) {
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called with a valid tripId.');
  }

  console.log(`Adding user ${uid} to trip ${tripId} with role ${userRole}.`);

  await trip.ref.update('users.'+uid+'.role', userRole);
})