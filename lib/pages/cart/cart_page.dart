import 'package:flutter/material.dart';
import 'package:mai_f/themes/theme_data.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(right: 22, left: 22, top:14),
        child: Container(
          child: Column(children: <Widget>[
            Text("My Cart", style: TextStyles.displayLarge,)
          ]),
        ),
      ),
    );
  }
}
