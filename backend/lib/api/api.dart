import 'package:api_agent/servers/shelf_router.dart';
import 'package:shared/api/app.server.dart';

import '../middleware/firebase_middleware.dart';
import 'links.dart';

final router = ShelfApiRouter([
  ApplyMiddleware(
    middleware: FirebaseMiddleware(),
    child: AppApiEndpoint.from(
      links: linksApi,
    ),
  ),
]);
