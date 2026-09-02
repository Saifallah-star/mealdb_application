import 'package:flutter_test/flutter_test.dart';
import 'package:mealdb_application/core/features/Filters/data/Models/meal_model.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_cubit.dart';
import 'package:mealdb_application/core/features/favorites__Local/cubit/favorites_state.dart';
import 'package:mealdb_application/core/features/favorites__Local/data/repo/favorites_local_dao.dart';
import 'package:mealdb_application/core/features/favorites__Local/data/repo/favorites_local_repo.dart';

class FakeFavoritesDAO implements FavoritesLocalDAO {
  final Map<String, List<MealModel>> _storage = {};

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);

  @override
  Future<void> addFavorite(MealModel meal, String userId) async {
    _storage.putIfAbsent(userId, () => []);
    _storage[userId]!.removeWhere((m) => m.id == meal.id);
    _storage[userId]!.add(meal);
  }

  @override
  Future<void> removeFavorite(int mealId, String userId) async {
    _storage[userId]?.removeWhere((m) => m.id == mealId.toString());
  }

  @override
  Future<List<MealModel>> getFavorites(String userId) async {
    return List.from(_storage[userId] ?? []);
  }

  @override
  Future<bool> isFavorite(int mealId, String userId) async {
    final list = _storage[userId] ?? [];
    return list.any((m) => m.id == mealId.toString());
  }
}

void main() {
  group('Favorites DAO & Repository Tests', () {
    late FakeFavoritesDAO fakeDao;
    late FavoritesLocalRepo repo;

    setUp(() {
      fakeDao = FakeFavoritesDAO();
      repo = FavoritesLocalRepo(dao: fakeDao);
    });

    test('addFavorite and getFavorites returns favorite for user', () async {
      final meal = MealModel(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
        imageUrl: 'https://image.com/1.jpg',
        Area: 'Japanese',
        Country: 'Japan',
      );

      await repo.addFavorite(meal, 'user1');
      final favsUser1 = await repo.getFavorites('user1');
      final favsUser2 = await repo.getFavorites('user2');

      expect(favsUser1.length, 1);
      expect(favsUser1.first.name, 'Teriyaki Chicken Casserole');
      expect(favsUser2.isEmpty, true);
    });

    test('isFavorite checks correctly', () async {
      final meal = MealModel(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
      );

      await repo.addFavorite(meal, 'user1');
      expect(await repo.isFavorite(52772, 'user1'), true);
      expect(await repo.isFavorite(52772, 'user2'), false);
      expect(await repo.isFavorite(99999, 'user1'), false);
    });

    test('removeFavorite deletes only matching meal and user', () async {
      final meal = MealModel(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
      );

      await repo.addFavorite(meal, 'user1');
      await repo.removeFavorite(52772, 'user1');

      expect(await repo.isFavorite(52772, 'user1'), false);
      expect((await repo.getFavorites('user1')).isEmpty, true);
    });
  });

  group('FavoritesCubit Tests', () {
    late FakeFavoritesDAO fakeDao;
    late FavoritesLocalRepo repo;
    late FavoritesCubit cubit;

    setUp(() {
      fakeDao = FakeFavoritesDAO();
      repo = FavoritesLocalRepo(dao: fakeDao);
      cubit = FavoritesCubit(repo: repo);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state is FavoritesInitial', () {
      expect(cubit.state is FavoritesInitial, true);
    });

    test('loadFavorites emits FavoritesLoading and FavoritesLoaded', () async {
      final meal = MealModel(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
      );
      await repo.addFavorite(meal, 'user1');

      final states = <FavoritesState>[];
      cubit.stream.listen(states.add);

      await cubit.loadFavorites('user1');
      await Future.delayed(const Duration(milliseconds: 10));

      expect(states.length, 2);
      expect(states[0] is FavoritesLoading, true);
      expect(states[1] is FavoritesLoaded, true);
      expect((states[1] as FavoritesLoaded).favorites.length, 1);
    });

    test('toggleFavorite adds then removes meal reactively', () async {
      final meal = MealModel(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
      );

      await cubit.toggleFavorite(meal, 'user1');
      expect(cubit.state is FavoritesLoaded, true);
      expect((cubit.state as FavoritesLoaded).favorites.length, 1);

      await cubit.toggleFavorite(meal, 'user1');
      expect(cubit.state is FavoritesLoaded, true);
      expect((cubit.state as FavoritesLoaded).favorites.isEmpty, true);
    });
  });
}
