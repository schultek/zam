import 'package:api_agent/api_agent.dart';

import '../models/models.dart';

class MapperCodec extends ApiCodec {
  const MapperCodec();

  @override
  T decode<T>(dynamic value) => Mapper.fromValue<T>(value);

  @override
  dynamic encode(dynamic value) => Mapper.toValue(value);
}
