import '../entities/pin_entity.dart';

abstract class HomeRepository {
  Future<List<PinEntity>> getPins({int page});
}
