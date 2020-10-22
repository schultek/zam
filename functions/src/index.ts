import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

export const updateUserRole = functions.https.onCall((data, context) => {

  if (!context.auth) {
    throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
        'while authenticated.');
  }

  const role = data.role; // "organizer" | "leader" | "participant"
  const uid = context.auth.uid;

  return admin.auth().setCustomUserClaims(uid, {role: role});
});