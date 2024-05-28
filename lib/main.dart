import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mai_f/pages/auth/page/registration_page.dart';
import 'package:mai_f/pages/start/start_screen.dart';
import 'package:mai_f/pages/main/main_page.dart';
import 'package:mai_f/repo/favorite/favorite_provider.dart';
import 'package:mai_f/repo/shop/shop_provider.dart';
import 'package:mai_f/themes/theme_data.dart';
import 'package:mai_f/repo/auth/auth_provider.dart';
import 'package:mai_f/widgets/product_item.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

var supabaseUrl = dotenv.env["SUPABASE_URL"];
var supabaseKey = dotenv.env["SUPABASE_KEY"];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Supabase.initialize(
      url: supabaseUrl as String, anonKey: supabaseKey as String);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ShopProvider()),
        ChangeNotifierProvider(
            create: (_) => FavoritesProvider(Supabase.instance.client)),
        ChangeNotifierProvider(create: (_) => CartProvider())
      ],
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shop',
      initialRoute: '/',
      routes: {
        '/': (context) => StartScreen(),
        '/registration': (context) => RegistrationPage(),
        '/main': (context) => MainPage(),
      },
      theme: lightTheme,
    );
  }
}
