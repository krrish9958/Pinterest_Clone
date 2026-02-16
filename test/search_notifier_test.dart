import 'package:flutter_test/flutter_test.dart';
import 'package:pinterest_clone/features/search/domain/entities/search_pin_entity.dart';
import 'package:pinterest_clone/features/search/domain/repositories/search_repository.dart';
import 'package:pinterest_clone/features/search/domain/usecases/search_pins_use_case.dart';
import 'package:pinterest_clone/features/search/presentation/providers/search_provider.dart';

class _FakeSearchRepository implements SearchRepository {
  @override
  Future<List<SearchPinEntity>> searchPins({
    required String query,
    int page = 1,
  }) async {
    if (query.isEmpty) return [];
    if (page == 1) {
      return [SearchPinEntity(id: 10, imageUrl: 'https://example.com/10.jpg')];
    }
    return [SearchPinEntity(id: 11, imageUrl: 'https://example.com/11.jpg')];
  }
}

void main() {
  test('SearchNotifier returns empty list for blank query', () async {
    final notifier = SearchNotifier(SearchPinsUseCase(_FakeSearchRepository()));

    await notifier.search('   ');

    expect(notifier.state.hasValue, isTrue);
    expect(notifier.state.value, isEmpty);
  });

  test('SearchNotifier loadMore appends results', () async {
    final notifier = SearchNotifier(SearchPinsUseCase(_FakeSearchRepository()));

    await notifier.search('nature');
    await notifier.loadMore();

    expect(notifier.state.hasValue, isTrue);
    expect(notifier.state.value!.length, 2);
    expect(notifier.state.value!.last.id, 11);
  });
}
