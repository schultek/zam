import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import '../providers/AppState.dart';

class DynamicLinkService {

  static Future<String> createTripCreatorLink() async {
    return buildDynamicLink({
      "claim": "canCreateTrips"
    }, meta: SocialMetaTagParameters(
      title: "Werde Organisator",
      description: "Erstelle und manage Freizeiten und andere Gruppen-Events.",
      imageUrl: Uri.parse("https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200"),
    ));
  }

  static Future<String> createAdminLink() async {
    return buildDynamicLink({
      "claim": "isAdmin"
    }, meta: SocialMetaTagParameters(
      title: "Werde Admin",
      description: "Erhalte Admin Rechte in der Jufa App.",
      imageUrl: Uri.parse("https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200"),
    ));
  }

  static Future<String> createParticipantLink(String tripId) async {
    return buildDynamicLink({
      "role": "participant",
      "tripId": tripId,
    }, meta: SocialMetaTagParameters(
      title: "Freizeit-Einladung",
      description: "Trete der Freizeit bei.",
      imageUrl: Uri.parse("https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200"),
    ));
  }

  static Future<String> createLeaderLink(String tripId) async {
    return buildDynamicLink({
      "role": "leader",
      "tripId": tripId,
    }, meta: SocialMetaTagParameters(
      title: "Werde Leiter",
      description: "Trete der Freizeit bei.",
      imageUrl: Uri.parse("https://www.pexels.com/photo/853168/download/?auto=compress&cs=tinysrgb&h=200&w=200"),
    ));
  }

  static Future<String> buildDynamicLink(Map<String, dynamic> params, {SocialMetaTagParameters meta}) async {
    String p = await createEncodedLinkParams(params);
    var parameters = DynamicLinkParameters(
        uriPrefix: "https://jufa.page.link",
        androidParameters: AndroidParameters(packageName: "de.schultek.jufa"),
        iosParameters: IosParameters(appStoreId: "1517699311", bundleId: "io.upride.jufa"),
        socialMetaTagParameters: meta,
        link: Uri.parse("https://jufa20.web.app/?$p"),
    );
    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();
    return dynamicUrl.shortUrl.toString();
  }

  static Future<void> handleDynamicLinks() async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    if (link != null) {
      await _handleDynamicLink(link);
    }

    FirebaseDynamicLinks.instance.onLink(onSuccess: (PendingDynamicLinkData link) async {
      await _handleDynamicLink(link);
    });
  }

  static Future<void> _handleDynamicLink(PendingDynamicLinkData link) async {
    var queryParameters = link.link.queryParameters;

    var updatedClaims = await receiveEncodedLinkParams(queryParameters);

    if (updatedClaims) {
      await AppState.instance.updateUserClaims(true);
    }
  }

  static Future<String> createEncodedLinkParams(Map<String, dynamic> params) async {
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "createEncodedLinkParams");
    var res = await callable.call(params);
    return res.data;
  }

  static Future<bool> receiveEncodedLinkParams(Map<String, dynamic> params) async {
    HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(functionName: "receiveEncodedLinkParams");
    var res = await callable.call(params);
    return res.data;
  }
}
