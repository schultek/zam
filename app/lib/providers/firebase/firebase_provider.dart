import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseProvider = FutureProvider((ref) => Firebase.initializeApp().whenComplete(() {
      FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);
    }));
