import 'package:firebase_auth/firebase_auth.dart';
import 'package:flu/Firebase_Realtime_Db/screen/realtime_screen.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';

class SignInProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get user => _auth.currentUser;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // The user canceled the sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if(user != null)
        {
          Get.to(MyHomePage());
        }
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<UserCredential?> signInWithFacebook() async {
    final LoginResult result = await FacebookAuth.instance.login();

    if (result.status == LoginStatus.success) {
      // Get the user's credentials
      final OAuthCredential credential = FacebookAuthProvider.credential(result.accessToken!.tokenString);
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } else {
      // Handle error or cancellation
      print(result.message);
      return null;
    }
  }


  Future<User?> signInWithGitHub() async {
    // // Replace with your GitHub OAuth credentials
    // final GitHubAuthProvider githubProvider = GitHubAuthProvider();
    //
    // // You can add scopes if needed
    // githubProvider.addScope('repo');
    // githubProvider.setCustomParameters({'allow_signup': 'false'});
    //
    // return await FirebaseAuth.instance.signInWithProvider(githubProvider);
  }



  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    notifyListeners();
  }
}
