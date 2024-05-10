import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mai_f/pages/auth/screen/email_screen.dart';
import 'package:mai_f/themes/theme_data.dart';
import 'package:mai_f/repo/auth/auth_provider.dart';
import 'package:mai_f/repo/auth/auth_service.dart';
import 'package:mai_f/utils/platform_utils.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});
  @override
  State<RegistrationPage> createState() => _RegistrationPage();
}

class _RegistrationPage extends State<RegistrationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/main', (Route<dynamic> route) => false);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 22.0),
              alignment: Alignment.center,
              child: Text('Skip', style: TextStyles.headlineSmall),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 22.0, right: 22, left: 22),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              children: [
                Text(
                  'Get all your online shopping in one place',
                  style: TextStyles.headlineLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: 400,
                  child: Text(
                    'To track your orders in Shop, connect the email you use for online shopping',
                    style: TextStyles.subtitle,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Expanded(
              flex: 1,
              child: Image.asset("assets/img/screen_1.png"),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () async {
                          if (PlatformUtils.isMobile) {
                            authProvider.signInWithGoogle(
                                success: () => {}, failed: (dynamic error) {});
                          }
                          authProvider.signInWithGoogleWeb(
                              success: () => {}, failed: (dynamic error) {});
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).colorScheme.primary,
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12.0,
                            horizontal: 20.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(Icons.account_circle),
                              const SizedBox(width: 10.0),
                              Text(
                                'Connect Google',
                                style: TextStyles.headlineSmall.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () async {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const EmailScreen(),
                      ),
                    );
                  },
                  child:const  Text(
                    "Sign in with Email",
                    style: TextStyles.headlineSmall,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
