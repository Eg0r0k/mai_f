import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesProvider with ChangeNotifier {
  final SupabaseClient _client;
  final Set<String> _favoriteProductIds = <String>{};

  FavoritesProvider(this._client);

  Set<String> get favoriteProductIds => _favoriteProductIds;
  Future<void> fetchFavorites(String clientId) async {
    try {
      final response =
          await _client.from('favorite').select().eq('client_id', clientId);
      print(response);
      if (response != null) {
        _favoriteProductIds.clear();
        for (var fav in response as List) {
          _favoriteProductIds.add(fav['product_id']);
        }
        notifyListeners();
      } else {
        print("Error fetching favorites: ${response}");
      }
    } catch (e) {
      print("Exception fetching favorites: $e");
    }
  }

  Future<bool> isFavorite(String productId) async {
    return _favoriteProductIds.contains(productId);
  }

  Future<void> toggleFavorite(String clientId, String productId) async {
    try {
      final isProductFavorite = await isFavorite(productId);
      print(productId);
      if (isProductFavorite) {
        final response = await _client
            .from('favorite')
            .delete()
            .eq('client_id', clientId)
            .eq('product_id', productId);

        if (response == null) {
          _favoriteProductIds.remove(productId);
          notifyListeners();
        } else {
          print("Error removing favorite: ${response}");
        }
      } else {
        try {
          final response = await _client
              .from('favorite')
              .insert({'client_id': clientId, 'product_id': productId});

          if (response == null) {
            _favoriteProductIds.add(productId);
            notifyListeners();
          } else {
            print("Error adding favorite: ${response}");
          }
        } catch (e) {
          if (e is PostgrestException && e.code == '23505') {
            _favoriteProductIds.add(productId);
            notifyListeners();
          } else {
            print("Exception adding favorite: $e");
          }
        }
      }
    } catch (e) {
      print("Exception toggling favorite: $e");
    }
  }
}
