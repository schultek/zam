import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart';

import '../../api_client/photoslibrary.dart';
import 'google_account_provider.dart';

final photosApiClientProvider = Provider((ref) => ((GoogleSignInAccount? user) => user != null
    ? AuthenticatedClient(Client(), () => user.authHeaders, user.clearAuthCache)
    : null)(ref.watch(googleAccountProvider)));

final photosApiProvider = Provider((ref) =>
    ((BaseClient? client) => client != null ? PhotosLibraryApi(client) : null)(ref.watch(photosApiClientProvider)));

class AuthenticatedClient extends BaseClient {
  final Client baseClient;
  final Future<Map<String, String>> Function() getAuthHeaders;
  final Future<void> Function() invalidHeadersCallback;

  AuthenticatedClient(
    this.baseClient,
    this.getAuthHeaders,
    this.invalidHeadersCallback,
  );

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    var authHeaders = await getAuthHeaders();
    request.headers.addAll(authHeaders);
    var response = await baseClient.send(request);
    if (response.statusCode == 401) {
      // Headers are expired, or perhaps user has been logged out.
      // GoogleSignIn expects clients to inform it of invalid cached headers.
      await invalidHeadersCallback();
    }
    return response;
  }

  @override
  void close() {
    super.close();
    baseClient.close();
  }
}
