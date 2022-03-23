import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment
} from "@firebase/rules-unit-testing";

let testEnv = await initializeTestEnvironment({
  projectId: "jufa20",
  firestore: {
    host: 'localhost',
    port: 8080,
  },
});

async function testRules() {

  const admin1 = testEnv.authenticatedContext("admin", {isOrganizer: true, isAdmin: true});
  const org1 = testEnv.authenticatedContext("org1", {isOrganizer: true});

  const bob = testEnv.authenticatedContext("bob");
  const tom = testEnv.authenticatedContext("tom");
  const alice = testEnv.authenticatedContext("alice");

  var tripData = {
    name: 'Test Trip', 
    template: {}, 
    users: {
      org1: {role: 'organizer'},
      alice: {role: 'participant'},
    }, 
    modules: {},
  };


  console.log(1);
  // no creation claim
  await assertFails(bob.firestore().doc('trips/1234').set(tripData));

  console.log(2);
  // not organizer in trip
  await assertFails(admin1.firestore().doc('trips/1234').set(tripData));
  
  console.log(3);
  await assertSucceeds(org1.firestore().doc('trips/1234').set(tripData));

  console.log(4);
  // not in trip
  await assertFails(tom.firestore().doc('trips/1234').get());

  console.log(5);
  // admin read everything
  await assertSucceeds(admin1.firestore().doc('trips/1234').get());
  

  console.log(6);
  // set nickname
  await assertSucceeds(alice.firestore().doc('trips/1234').update({users: {alice: {nickname: 'Alice'}}}));

  console.log(7);
  // add tom to trip
  await assertSucceeds(org1.firestore().doc('trips/1234').update({users: {tom: {role: 'participant'}}}));

  console.log(8);
  // cannot update other user
  await assertFails(alice.firestore().doc('trips/1234').update({users: {tom: {nickname: 'Dumby'}}}));


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
