import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../bloc/auth_bloc.dart';
import '../helpers/locator.dart';
import '../models/models.dart';

class DynamicLinkService {
  DynamicLinkService() {
    // var link =
    //     "https://jufa20.web.app/invitation/organizer?phoneNumber=%2B4915787693846&hmac=753651ea7a018e59caf62a63a0791a785e91131025c8efe04e73d8f02eb889fd";
    // _buildDynamicLink(
    //   link: link,
    //   meta: SocialMetaTagParameters(
    //     title: "Werde Organisator",
    //     description: "Erstelle und manage Ausflüge und andere Gruppen-Events.",
    //     imageUrl: Uri.parse("https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200"),
    //   ),
    // ).then(print);
  }

  Future<void> setup() async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    if (link != null) {
      print("Got initial dynamic link");
      _handleDynamicLink(link);
    }

    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData? link) async {
      await _handleDynamicLink(link);
    });
  }

  Future<void> _handleDynamicLink(PendingDynamicLinkData? link) async {
    if (link == null) return;

    var uri = link.link;
    if (uri.path.startsWith('/invitation')) {
      locator<AuthBloc>().handleInvitationLink(uri);
    }
  }

  Future<String> createOrganizerLink({required String phoneNumber}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createOrganizerLink');
    var res = await callable.call({'phoneNumber': phoneNumber});
    return _buildDynamicLink(
      link: res.data as String,
      meta: SocialMetaTagParameters(
        title: "Werde Organisator",
        description: "Erstelle und manage Ausflüge und andere Gruppen-Events.",
        imageUrl: Uri.parse("https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200"),
      ),
    );
  }

  Future<String> createAdminLink({required String phoneNumber}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createAdminLink');
    var res = await callable.call({'phoneNumber': phoneNumber});
    return _buildDynamicLink(
      link: res.data as String,
      meta: SocialMetaTagParameters(
        title: "Werde Admin",
        description: "Erhalte Admin Rechte in der Jufa App.",
        imageUrl: Uri.parse("https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200"),
      ),
    );
  }

  Future<String> createTripInvitationLink({required String tripId, String role = UserRoles.Participant}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createTripInvitationLink');
    var res = await callable.call({'tripId': tripId, 'role': role});
    return _buildDynamicLink(
      link: res.data as String,
      meta: SocialMetaTagParameters(
        title: role == UserRoles.Leader ? "Werde Ausflugs-Leiter" : "Ausflugs-Einladung",
        description: "Trete dem Ausflug bei.",
        imageUrl: Uri.parse("https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200"),
      ),
    );
  }

  Future<void> handleReceivedLink(Uri link) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('onLinkReceived');
    var res = await callable.call({'link': link.toString()});
    var claimsChanged = res.data as bool;
    if (claimsChanged) {
      await locator<AuthBloc>().updateUserClaims(true);
    }
  }

  Future<String> _buildDynamicLink({required String link, SocialMetaTagParameters? meta}) async {
    var parameters = DynamicLinkParameters(
      uriPrefix: "https://jufa.page.link",
      androidParameters: AndroidParameters(packageName: "de.schultek.jufa"),
      iosParameters: IosParameters(appStoreId: "1517699311", bundleId: "io.upride.jufa"),
      socialMetaTagParameters: meta,
      link: Uri.parse(link),
    );
    ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
  }
}
