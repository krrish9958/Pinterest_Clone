import 'package:flutter_test/flutter_test.dart';
import 'package:pinterest_clone/features/home/data/domain/entities/pin_entity.dart';
import 'package:pinterest_clone/features/home/data/domain/repositories/home_repository.dart';
import 'package:pinterest_clone/features/home/data/domain/usecases/get_pins_use_case.dart';
import 'package:pinterest_clone/features/home/presentation/providers/home_provider.dart';

class _FakeHomeRepository implements HomeRepository {
  @override
  Future<List<PinEntity>> getPins({int page = 1}) async {
    if (page == 1) {
      return [
        PinEntity(
          id: 1,
          imageUrl: 'https://example.com/1.jpg',
          author: 'Author 1',
          title: 'Title 1',
        ),
        PinEntity(
          id: 2,
          imageUrl: 'https://example.com/2.jpg',
          author: 'Author 2',
          title: 'Title 2',
        ),
      ];
    }

    return [
      PinEntity(
        id: 3,
        imageUrl: 'https://example.com/3.jpg',
        author: 'Author 3',
        title: 'Title 3',
      ),
    ];
  }
}

void main() {
  test('HomeNotifier fetches initial pins', () async {
    final notifier = HomeNotifier(GetPinsUseCase(_FakeHomeRepository()));

    await Future<void>.delayed(Duration.zero);

    expect(notifier.state.hasValue, isTrue);
    expect(notifier.state.value, isNotNull);
    expect(notifier.state.value!.length, 2);
  });

  test('HomeNotifier loadMorePins appends data', () async {
    final notifier = HomeNotifier(GetPinsUseCase(_FakeHomeRepository()));
    await Future<void>.delayed(Duration.zero);

    await notifier.loadMorePins();

    expect(notifier.state.hasValue, isTrue);
    expect(notifier.state.value!.length, 3);
    expect(notifier.state.value!.last.id, 3);
  });
}
