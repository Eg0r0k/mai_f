import 'package:flutter/material.dart';
import 'package:mai_f/pages/product/product_page.dart';
import 'package:mai_f/repo/auth/auth_provider.dart';
import 'package:mai_f/repo/cart/cart_provider.dart';
import 'package:mai_f/repo/favorite/favorite_provider.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatefulWidget {
  final Map<String, dynamic> product;

  const ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  _ProductItemState createState() => _ProductItemState();
}

class _ProductItemState extends State<ProductItem> {
  bool _isFavorite = false;
  bool _isLoadingFavorite = true;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);
    final productId = widget.product['id'].toString();
    _isFavorite = await favoritesProvider.isFavorite(productId);
    setState(() {
      _isLoadingFavorite = false;
    });
  }

  void _toggleFavorite(BuildContext context) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final favoritesProvider =
        Provider.of<FavoritesProvider>(context, listen: false);

    final clientId = authProvider.userInfo?.id ?? '';

    if (clientId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You must be logged in to favorite items.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoadingFavorite = true;
    });

    final productId = widget.product['id'].toString();
    await favoritesProvider.toggleFavorite(clientId, productId);
    _isFavorite = await favoritesProvider.isFavorite(productId);

    setState(() {
      _isLoadingFavorite = false;
    });
  }

  void _addToCart(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);
    cartProvider.addToCart(widget.product);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final productId = widget.product['id'].toString();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductPage(product: widget.product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 5,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: AssetImage(
                      'assets/img/placeholder.webp',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                widget.product['name'] ?? 'Product Name',
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 4),
              Text(
                widget.product['description'] ?? 'Product Description',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${widget.product['price']?.toStringAsFixed(2) ?? '0.00'}',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: _isLoadingFavorite
                        ? CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          )
                        : Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: _isFavorite ? Colors.red : Colors.grey,
                          ),
                    onPressed: () => _toggleFavorite(context),
                  ),
                  ElevatedButton(
                    onPressed: () => _addToCart(context),
                    child: Text('Add to Cart'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

