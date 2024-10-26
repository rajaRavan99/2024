import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

import 'google_sign_provider.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signInProvider = Provider.of<SignInProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Sign In')),
      body: Column(
        children: [
          Center(
            child: signInProvider.user == null
                ? ElevatedButton(
                    onPressed: () => signInProvider.signInWithGoogle(),
                    child: const Text('Sign in with Google'),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Hello, ${signInProvider.user!.displayName}'),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => signInProvider.signOut(),
                        child: const Text('Sign Out'),
                      ),
                    ],
                  ),
          ),

          const SizedBox(
            height: 10.0,
          ),

          SignInButton(
            Buttons.facebook,
            text: "Sign in with Facebook",
            onPressed: () {
              // Call your Facebook Sign-In function
              signInProvider.signInWithFacebook();
            },
          ),

          // GitHub Sign-In Button
          SignInButton(
            Buttons.gitHub,
            text: "Sign in with GitHub",
            onPressed: () {
              // Call your GitHub Sign-In function
              signInProvider.signInWithGitHub();
            },
          ),
        ],
      ),
    );
  }
}
