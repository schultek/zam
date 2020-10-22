import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();

export const updateUserRole = functions.https.onCall(async (data, context) => {

  if (!context.auth) {
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called while authenticated.');
  }
  if (!data.role || !["organizer", "leader", "participant"].includes(data.role)) {
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called with a valid role.');
  }

  const role = data.role; // "organizer" | "leader" | "participant"
  const uid = context.auth.uid;

  console.log(`Setting role of user ${uid} to '${role}'.`);

  await admin.auth().setCustomUserClaims(uid, {role: role});
});