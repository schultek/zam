import 'package:api_agent/api_agent.dart';

import '../../models/models.dart';

@ApiDefinition()
abstract class AdminApi {
  Future<List<UserData>> getAllUsers();
  Future<void> setClaims(String userId, UserClaims claims);
}
