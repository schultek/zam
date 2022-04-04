import 'package:api_agent/servers/shelf_router.dart';
import 'package:shared/api/app.server.dart';

import '../middleware/auth_middleware.dart';
import '../middleware/firebase_middleware.dart';
import 'links.dart';
import 'modules/announcement.dart';
import 'modules/chat.dart';

final router = ShelfApiRouter([
  ApplyMiddleware(
    middleware: FirebaseMiddleware(),
    child: ApplyMiddleware(
      middleware: AuthMiddleware(),
      child: AppApiEndpoint.from(
        links: linksApi,
        announcement: announcementApi,
        chat: chatApi,
      ),
    ),
  ),
]);
