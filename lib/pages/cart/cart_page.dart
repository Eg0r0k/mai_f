import 'package:flutter/material.dart';
import 'package:mai_f/widgets/product_item.dart';
import 'package:provider/provider.dart';

import 'package:mai_f/themes/theme_data.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Cart", style: TextStyles.displayLarge),
      ),
      body: Padding(
        padding: EdgeInsets.all(22),
        child: Consumer<CartProvider>(
          builder: (context, cartProvider, child) {
            return Column(
              children: <Widget>[
       
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.cartItems.length,
                    itemBuilder: (context, index) {
                      final product = cartProvider.cartItems[index];
                      return ListTile(
                        title: Text(product['name']),
                        subtitle: Text(
                          '\$${product['price']?.toStringAsFixed(2) ?? '0.00'} x ${product['quantity']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                cartProvider
                                    .removeFromCart(product['id'].toString());
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                cartProvider.addToCart(product);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                cartProvider.removeAllFromCart(
                                    product['id'].toString());
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Text(
                  'Total: \$${cartProvider.getTotalPrice().toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    cartProvider.placeOrder();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Order placed successfully!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Text('Place Order'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
