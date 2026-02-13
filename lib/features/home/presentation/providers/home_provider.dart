import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinterest_clone/features/home/data/domain/entities/pin_entity.dart';
import 'package:pinterest_clone/features/home/data/domain/repositories/home_repository.dart';
import '../../data/datasources/home_remote_datasource.dart';
import '../../data/repositories/home_repository_impl.dart';

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl(HomeRemoteDataSource());
});

class HomeNotifier extends StateNotifier<AsyncValue<List<PinEntity>>> {
  final HomeRepository repository;
  int _page = 1;
  bool _isLoadingMore = false;

  HomeNotifier(this.repository) : super(const AsyncValue.loading()) {
    fetchInitialPins();
  }

  Future<void> fetchInitialPins() async {
    state = const AsyncValue.loading();
    try {
      final pins = await repository.getPins(page: 1);
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
      final newPins = await repository.getPins(page: _page + 1);

      _page++;
      state = AsyncValue.data([...currentPins, ...newPins]);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }

    _isLoadingMore = false;
  }

  Future<void> refreshPins() async {
    try {
      _page = 1 + DateTime.now().second % 5;
      // random page between 1–5

      final pins = await repository.getPins(page: _page);
      state = AsyncValue.data(pins);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final homeProvider =
    StateNotifierProvider<HomeNotifier, AsyncValue<List<PinEntity>>>((ref) {
      final repo = ref.read(homeRepositoryProvider);
      return HomeNotifier(repo);
    });
