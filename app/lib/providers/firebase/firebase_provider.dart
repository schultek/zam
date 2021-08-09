import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseProvider = FutureProvider((ref) => Firebase.initializeApp());
