import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin IAuthRepository {
  Future<AuthResponse> onSignUpWithEmail(email, password);
  Future<AuthResponse> onSingUpWithGoogle();
  Future<void> signOut();
  bool isLogin();
}

class AuthRepository with IAuthRepository {
  final supabase = Supabase.instance;

  @override
  Future<AuthResponse> onSignUpWithEmail(password, email) {
    return supabase.client.auth
        .signInWithPassword(password: password, email: email);
  }

  @override
  Future<void> signOut() async {
    await supabase.client.auth.signOut();
  }

  @override
  Future<AuthResponse> onSingUpWithGoogle() async {
    var webClientId = dotenv.env["GOOGLE_CLIENT_ID"];
    const iosClientId = 'my-ios.apps.googleusercontent.com';
    final GoogleSignIn googleSignIn =
        GoogleSignIn(clientId: iosClientId, serverClientId: webClientId);
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in was cancelled by the user.');
    }
    final googleAuth = await googleUser.authentication;
    final accessToken = googleAuth.accessToken;
    final idToken = googleAuth.idToken;
    if (accessToken == null) {
      throw 'No access token';
    }
    if (idToken == null) {
      throw 'No id token';
    }
    return supabase.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken);
  }

  @override
  bool isLogin() => supabase.client.auth.currentUser != null;
}
