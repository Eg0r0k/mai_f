import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mai_f/repo/auth/auth_provider.dart';
import 'package:mai_f/repo/favorite/favorite_provider.dart';
import 'package:mai_f/repo/shop/shop_provider.dart';
import 'package:mai_f/themes/theme_data.dart';
import 'package:mai_f/widgets/corusel_main.dart';
import 'package:mai_f/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.fetchUserInfo();
      Provider.of<FavoritesProvider>(context, listen: false)
          .fetchFavorites(authProvider.userInfo?.id ?? '');
    });
    Provider.of<ShopProvider>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {

    double baseSpacing = 10.0;

    int columns = MediaQuery.of(context).size.width > 1200
        ? 4
        : MediaQuery.of(context).size.width > 900
            ? 3
            : MediaQuery.of(context).size.width > 350
                ? 2
                : 1;


    double screenWidth = MediaQuery.of(context).size.width;
    double totalHorizontalPadding = 20;
    double totalSpacingWidth = (columns - 1) * baseSpacing;
    double width =
        (screenWidth - totalHorizontalPadding - totalSpacingWidth) / columns;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearch());
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: ScrollConfiguration(
        behavior: MyCustomScrollBehavior(),
        child: RefreshIndicator(
          onRefresh: () async {
            Provider.of<ShopProvider>(context, listen: false).fetchProducts();
          },
          child: SingleChildScrollView(
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: <Widget>[
                MainCorusel(),
                Container(
                  padding: EdgeInsets.only(left: 14, top: 25, bottom: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Products",
                    style: TextStyles.displayLarge,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Consumer<ShopProvider>(
                    builder: (context, shopProvider, child) {
                      final products = shopProvider.products;
                      return Wrap(
                        spacing: baseSpacing,
                        runSpacing: baseSpacing,
                        children: List.generate(products.length, (index) {
                          return Container(
                            width: width,
                            child: ProductItem(product: products[index]),
                          );
                        }),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

class CustomSearch extends SearchDelegate {
  List<String> data = ['Popular', 'Text', 'Test2'];

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: AppBarTheme(color: Theme.of(context).colorScheme.background),
    );
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> matchQuery = data
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          onTap: () {
            query = result;
          },
          title: Text(result),
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<String> matchQuery = data
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        var result = matchQuery[index];
        return ListTile(
          title: Text(result),
        );
      },
    );
  }
}
