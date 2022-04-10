import 'package:api_agent/api_agent.dart';

import 'core/admin.dart';
import 'core/links.dart';
import 'mapper_codec.dart';
import 'modules/announcement.dart';
import 'modules/chat.dart';

@ApiDefinition(codec: MapperCodec())
abstract class AppApi {
  LinksApi get links;
  AdminApi get admin;
  AnnouncementApi get announcement;
  ChatApi get chat;
}
