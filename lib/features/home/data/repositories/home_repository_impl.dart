import 'package:pinterest_clone/features/home/data/domain/entities/pin_entity.dart';
import 'package:pinterest_clone/features/home/data/domain/repositories/home_repository.dart';

import '../datasources/home_remote_datasource.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<PinEntity>> getPins({int page = 1}) async {
    final pins = await remoteDataSource.fetchPins(page: page);
    return pins.map((e) => PinEntity(id: e.id, imageUrl: e.imageUrl)).toList();
  }
}
