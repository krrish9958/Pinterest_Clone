import 'package:pinterest_clone/features/home/data/domain/entities/pin_entity.dart';
import 'package:pinterest_clone/features/home/data/domain/repositories/home_repository.dart';

class GetPinsUseCase {
  final HomeRepository repository;

  GetPinsUseCase(this.repository);

  Future<List<PinEntity>> call({required int page}) {
    return repository.getPins(page: page);
  }
}
