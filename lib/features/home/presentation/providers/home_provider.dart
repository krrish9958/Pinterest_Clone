import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/home/data/datasources/home_remote_datasource.dart';
import 'package:pinterest_clone/features/home/data/domain/entities/pin_entity.dart';
import 'package:pinterest_clone/features/home/data/domain/repositories/home_repository.dart';
import 'package:pinterest_clone/features/home/data/domain/usecases/get_pins_use_case.dart';
import 'package:pinterest_clone/features/home/data/repositories/home_repository_impl.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(HomeRemoteDataSource());
});

final getPinsUseCaseProvider = Provider<GetPinsUseCase>((ref) {
  final repository = ref.read(homeRepositoryProvider);
  return GetPinsUseCase(repository);
});

class HomeNotifier extends StateNotifier<AsyncValue<List<PinEntity>>> {
  final GetPinsUseCase getPinsUseCase;
  int _page = 1;
  bool _isLoadingMore = false;

  HomeNotifier(this.getPinsUseCase) : super(const AsyncValue.loading()) {
    fetchInitialPins();
  }

  Future<void> fetchInitialPins() async {
    state = const AsyncValue.loading();
    try {
      final pins = await getPinsUseCase(page: 1);
      _page = 1;
      state = AsyncValue.data(pins);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> loadMorePins() async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;

    try {
      final currentPins = state.value ?? [];
      final newPins = await getPinsUseCase(page: _page + 1);
      _page++;
      state = AsyncValue.data([...currentPins, ...newPins]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
    }
  }

  Future<void> refreshPins() async {
    try {
      _page = 1 + DateTime.now().second % 5;
      final pins = await getPinsUseCase(page: _page);
      state = AsyncValue.data(pins);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final homeProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<List<PinEntity>>>((ref) {
      final useCase = ref.read(getPinsUseCaseProvider);
      return HomeNotifier(useCase);
    });
