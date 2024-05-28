import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:mai_f/repo/shop/shop_service.dart';

class ShopProvider extends ChangeNotifier {
  final _repo = ShopRepository();

  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _favorite = [];
  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get favorite => _favorite;
  void fetchProducts() async {
    final supabase = Supabase.instance;
    final db = supabase.client;

    final response = await db.from('product').select('*');
    _products = response as List<Map<String, dynamic>>;
    notifyListeners();
  }

  void fetchFavorite(int userId) async {
    final supabase = Supabase.instance;
    final db = supabase.client;

    final response =
        await db.from('favorite').select('*').filter('user_id', 'eq', userId);
    _favorite = response as List<Map<String, dynamic>>;
    notifyListeners();
  }
}
