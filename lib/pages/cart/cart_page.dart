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
                      return Card(
                        color: Colors.black,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: ListTile(
                          contentPadding: EdgeInsets.all(15),
                          title: Text(product['name'],
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          subtitle: Text(
                            '\$${product['price']?.toStringAsFixed(2) ?? '0.00'} x ${product['quantity']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                color: Colors.white,
                                onPressed: () {
                                  cartProvider
                                      .removeFromCart(product['id'].toString());
                                },
                              ),
                              Text(
                                product['quantity'].toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add),
                                color: Colors.white,
                                onPressed: () {
                                  cartProvider.addToCart(product);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cartProvider.removeAllFromCart(
                                      product['id'].toString());
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Divider(thickness: 2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${cartProvider.getTotalPrice().toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
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
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    textStyle: TextStyle(fontSize: 18),
                  ),
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
