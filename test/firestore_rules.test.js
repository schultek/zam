import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment
} from "@firebase/rules-unit-testing";

import firebase from 'firebase/compat/app';
import "firebase/compat/firestore";

let testEnv = await initializeTestEnvironment({
  projectId: "jufa20",
  firestore: {
    host: 'localhost',
    port: 8080,
  },
});

async function testRules() {

  const admin1 = testEnv.authenticatedContext("admin", {isOrganizer: true, isAdmin: true}).firestore();
  const org1 = testEnv.authenticatedContext("org1", {isOrganizer: true}).firestore();

  const bob = testEnv.authenticatedContext("bob").firestore();
  const tom = testEnv.authenticatedContext("tom").firestore();
  const alice = testEnv.authenticatedContext("alice").firestore();

  var groupData = {
    name: 'Test Group', 
    template: {}, 
    users: {
      org1: {role: 'organizer'},
      alice: {role: 'participant'},
    }, 
    modules: {},
  };

  // TRIP & USERS

  // no creation claim
  await assertFails(bob.doc('groups/1234').set(groupData));

  // not organizer in group
  await assertFails(admin1.doc('groups/1234').set(groupData));
  
  await assertSucceeds(org1.doc('groups/1234').set(groupData));

  // not in group
  await assertFails(tom.doc('groups/1234').get());

  // admin read everything
  await assertSucceeds(admin1.doc('groups/1234').get());
  
  // set nickname
  await assertSucceeds(alice.doc('groups/1234').update('users.alice.nickname', 'Alice'));

  // add tom to group
  await assertSucceeds(org1.doc('groups/1234').update('users.tom', {role: 'participant'}));

  // cannot update other user
  await assertFails(alice.doc('groups/1234').update('users.tom.nickname', 'Dumby'));

  // THE BUTTON
  
  await assertSucceeds(alice.doc('groups/1234/modules/thebutton').set({aliveHours: 1, lastReset: firebase.firestore.FieldValue.serverTimestamp(), leaderboard: {}}));
}

try {
  await testRules();
} catch (e) {
  console.log(e);
}

console.log("clear");
await testEnv.clearFirestore();
console.log("Cleanup");
await testEnv.cleanup();
