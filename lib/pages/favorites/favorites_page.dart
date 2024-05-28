import 'package:flutter/material.dart';
import 'package:mai_f/repo/auth/auth_provider.dart';
import 'package:mai_f/repo/favorite/favorite_provider.dart';
import 'package:mai_f/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<List<dynamic>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _fetchFavoritedProducts();
  }

  Future<List<dynamic>> _fetchFavoritedProducts() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final clientId = authProvider.userInfo?.id ?? '';
      if (clientId.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You must be logged in.')),
        );
        return [];
      }

      final favoriteResponse = await Supabase.instance.client
          .from('favorite')
          .select(
            'product_id ',
          )
          .eq('client_id', clientId);

      if (favoriteResponse == null) {
        throw Exception(favoriteResponse);
      }

      final favoriteData = favoriteResponse as List<dynamic>;
      final favoriteProductIds =
          favoriteData.map((e) => e['product_id']).toList();

      final productList = <dynamic>[];
      for (var id in favoriteProductIds) {
        final response = await Supabase.instance.client
            .from('product')
            .select(
              'id, name, price',
            )
            .eq('id', id);
        print(response);
        productList.add(response[0]);
      }

      return productList;
    } catch (e) {
      debugPrint('Error fetching favorites: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favorites')),
      body: FutureBuilder<List<dynamic>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final favoritedProducts = snapshot.data ?? [];

            if (favoritedProducts.isEmpty) {
              return Center(child: Text('No favorites found'));
            }

            // Build the list view of products
            return ListView.builder(
              itemCount: favoritedProducts.length,
              itemBuilder: (context, index) {
                final product = favoritedProducts[index];
                return ListTile(
                  title: Text(product['name']),
                  subtitle: Text('Price: ${product['price']}'),
                );
              },
            );
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
