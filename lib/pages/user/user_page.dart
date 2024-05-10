import 'package:flutter/material.dart';
import 'package:mai_f/main.dart';
import 'package:mai_f/themes/theme_data.dart';
import 'package:mai_f/repo/auth/auth_provider.dart';
import 'package:mai_f/utils/platform_utils.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _checkAuth();
    });
  }

  void _checkAuth() {
    Provider.of<AuthProvider>(context, listen: false).onCheckScreenAuth(
      auth: () {
        print("Пользователь вошел в систему");
      },
      unAuth: () {
        Navigator.pushNamed(context, '/registration');
      },
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          surfaceTintColor: Colors.white,
          title: Text(
            'Выход',
            style: TextStyles.displayMedium,
          ),
          content: Text('Вы уверены, что хотите выйти?'),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Отмена',
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Выйти',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _signOut();
              },
            ),
          ],
        );
      },
    );
  }

  void _signOut() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.signOut(
      success: () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => App()));
      },
      failed: (dynamic error) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Ошибка выхода: $error")));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
              onPressed: () {
                _showSignOutDialog();
              },
              icon: Icon(Icons.logout_rounded))
        ],
      ),
      body: Row(
        children: [
          TextButton(
            child: Text('Check'),
            onPressed: () async {
              _checkAuth();
            },
          ),
          TextButton(
            child: Text('singIn google'),
            onPressed: () async {
              if (PlatformUtils.isMobile) {
                Provider.of<AuthProvider>(context, listen: false)
                    .signInWithGoogle(
                        success: () => {}, failed: (dynamic error) {});
              } else {
                Provider.of<AuthProvider>(context, listen: false)
                    .signInWithGoogleWeb(
                        success: () => {}, failed: (dynamic error) {});
              }
            },
          ),
        ],
      ),
    );
  }
}
