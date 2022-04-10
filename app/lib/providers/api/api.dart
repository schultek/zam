import 'package:api_agent/clients/http_client.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/api/app.client.dart';

const apiDomain = String.fromEnvironment('API_DOMAIN', defaultValue: 'https://api-service-jzndyop6ka-ew.a.run.app');

final apiProtocolProvider = Provider((ref) => HttpApiClient(
      domain: apiDomain.startsWith('http') ? apiDomain : 'http://$apiDomain',
      providers: [FirebaseAuthProvider()],
    ));

final apiProvider = Provider((ref) => AppApiClient(
      ref.read(apiProtocolProvider),
    ));

class FirebaseAuthProvider implements ApiProvider<HttpApiRequest> {
  @override
  Future<HttpApiRequest> apply(HttpApiRequest request) async {
    if (FirebaseAuth.instance.currentUser != null) {
      var token = await FirebaseAuth.instance.currentUser!.getIdToken();
      return request.change(headers: {'Authorization': 'Bearer $token'});
    }
    return request;
  }
}
