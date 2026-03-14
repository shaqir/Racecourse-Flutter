import 'package:flutter_test/flutter_test.dart';
import 'package:racecourse_tracks/data/services/cloud_functions_service.dart';
import 'package:racecourse_tracks/data/services/firestore_service.dart';
import 'package:racecourse_tracks/data/repositories/racecourse_repository.dart';

/// Minimal fakes that implement the service interfaces without Firebase.
class _FakeCloudFunctionsService implements CloudFunctionsService {
  @override
  Future<Map<String, dynamic>> refreshRacecourseData(String racecourseId) async => {};
}

class _FakeFirestoreService implements FirestoreService {
  @override
  Future<List<Map<String, dynamic>>> getRacecourses() async => [];
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

RacecourseRepository _createRepository() {
  return RacecourseRepository(
    cloudFunctionsService: _FakeCloudFunctionsService(),
    firestoreService: _FakeFirestoreService(),
  );
}

void main() {
  group('RacecourseRepository', () {
    group('selectedItems sorting', () {
      test('sorts by type: Gallops before Harness before Greyhound', () async {
        final repo = _createRepository();

        final items = {
          {
            'Racecourse': 'Track C',
            'Racecourse Type': 'Greyhound',
            'isSelected': true,
            'isFavorite': false,
          },
          {
            'Racecourse': 'Track A',
            'Racecourse Type': 'Gallops',
            'isSelected': true,
            'isFavorite': false,
          },
          {
            'Racecourse': 'Track B',
            'Racecourse Type': 'Harness',
            'isSelected': true,
            'isFavorite': false,
          },
        };

        // Set allItems first, then load them as selected to populate _savedItems
        repo.setAllItems(items);
        await repo.loadSelectedItems(items);

        final sorted = repo.selectedItems.toList();
        expect(sorted.length, 3);
        expect(sorted[0]['Racecourse Type'], 'Gallops');
        expect(sorted[1]['Racecourse Type'], 'Harness');
        expect(sorted[2]['Racecourse Type'], 'Greyhound');
      });

      test('returns empty set when no items are selected', () {
        final repo = _createRepository();
        repo.setAllItems({
          {
            'Racecourse': 'Track A',
            'Racecourse Type': 'Gallops',
            'isSelected': false,
            'isFavorite': false,
          },
        });
        expect(repo.selectedItems, isEmpty);
      });
    });

    group('areMapsEqualIgnoringField', () {
      test('returns true when maps differ only in ignored fields', () {
        final repo = _createRepository();
        final map1 = {'Name': 'Ascot', 'isSelected': true, 'isFavorite': false};
        final map2 = {'Name': 'Ascot', 'isSelected': false, 'isFavorite': true};
        expect(
          repo.areMapsEqualIgnoringField(map1, map2, 'isSelected', 'isFavorite'),
          isTrue,
        );
      });

      test('returns false when maps differ in non-ignored fields', () {
        final repo = _createRepository();
        final map1 = {'Name': 'Ascot', 'isSelected': true, 'isFavorite': false};
        final map2 = {'Name': 'Cheltenham', 'isSelected': true, 'isFavorite': false};
        expect(
          repo.areMapsEqualIgnoringField(map1, map2, 'isSelected', 'isFavorite'),
          isFalse,
        );
      });
    });

    group('areMapsEqual', () {
      test('returns true for identical maps', () {
        final repo = _createRepository();
        final map = {'Name': 'Ascot', 'Type': 'Gallops'};
        expect(repo.areMapsEqual(map, Map.from(map)), isTrue);
      });

      test('returns false when second map is missing a key', () {
        final repo = _createRepository();
        final map1 = {'Name': 'Ascot', 'Type': 'Gallops'};
        final map2 = {'Name': 'Ascot'};
        expect(repo.areMapsEqual(map1, map2), isFalse);
      });
    });

    group('resetAll', () {
      test('sets isSelected and isFavorite to false on all items', () {
        final repo = _createRepository();
        repo.setAllItems({
          {
            'Racecourse': 'Ascot',
            'Racecourse Type': 'Gallops',
            'isSelected': true,
            'isFavorite': true,
          },
        });
        repo.resetAll();
        for (var item in repo.allItems) {
          expect(item['isSelected'], false);
          expect(item['isFavorite'], false);
        }
      });
    });

    group('toggleSelection', () {
      test('sets isSelected on the matching item in allItems', () async {
        final repo = _createRepository();
        final item = {
          'Racecourse': 'Ascot',
          'Racecourse Type': 'Gallops',
          'isSelected': false,
          'isFavorite': false,
        };
        repo.setAllItems({item});

        await repo.toggleSelection(item, true);

        expect(repo.allItems.first['isSelected'], true);
      });
    });
  });
}
