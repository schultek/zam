import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

import 'AuthService.dart';
import 'BackendService.dart';

class DynamicLinkService {
  static Future<String> createOrganizerLink() async {
    var parameters = DynamicLinkParameters(
        uriPrefix: "https://jufa.page.link",
        androidParameters: AndroidParameters(packageName: "de.schultek.jufa"),
        link: Uri.parse("https://jufa20.web.app/?isOrganizer=yes"));
    final Uri dynamicUrl = await parameters.buildUrl();
    return dynamicUrl.toString();
  }
  static void handleDynamicLinks() async {
    var link = await FirebaseDynamicLinks.instance.getInitialLink();
    if (link != null) {
      _handleDynamicLink(link);
    }

    FirebaseDynamicLinks.instance.onLink(
      onSuccess: (PendingDynamicLinkData link) async {
        _handleDynamicLink(link);
      }
    );
  }
  static void _handleDynamicLink(PendingDynamicLinkData link) async {

    var queryParameters = link.link.queryParameters;
    if (queryParameters.containsKey("isOrganizer")) {
      if (queryParameters["isOrganizer"] == "yes") {
        await BackendService.updateUserRole("organizer");
      }
    }

    await AuthService.getUser().reload();
  }
}
