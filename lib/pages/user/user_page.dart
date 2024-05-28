import 'package:flutter/material.dart';
import 'package:mai_f/main.dart';
import 'package:mai_f/themes/theme_data.dart';
import 'package:mai_f/repo/auth/auth_provider.dart';
import 'package:provider/provider.dart';

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
      Provider.of<AuthProvider>(context, listen: false).fetchUserInfo();
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
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Profile",
          style: TextStyles.displayLarge,
        ),
        actions: [
          IconButton(
            onPressed: _showSignOutDialog,
            icon: Icon(Icons.logout_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.0),
            _buildUserInfo(authProvider),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(AuthProvider authProvider) {
    if (authProvider.userInfo != null) {
      return Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoRow('ID:', authProvider.userInfo?.id ?? ''),
              SizedBox(height: 8.0),
              _buildInfoRow('Email:', authProvider.userInfo?.email ?? ''),
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('No user info available', style: TextStyles.body),
        ),
      );
    }
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyles.body),
        Text(value, style: TextStyles.body.copyWith(color: Colors.grey[600])),
      ],
    );
  }
}
