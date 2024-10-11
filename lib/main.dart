import 'package:flu/Firebase_Realtime_Db/screen/realtime_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'Cloud_firestore/provider/user_provider.dart';
import 'Firebase_Realtime_Db/provider/provider_file.dart';
import 'google_sign_in/Screen.dart';
import 'google_sign_in/google_sign_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeFirebase();
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      // Firebase is already initialized, do nothing
    } else {
      // Handle other initialization errors
      print('Firebase initialization error: $e');
    }
  }
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ItemProvider()),
        ChangeNotifierProvider(create: (_) => SignInProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  SignInScreen(),
    );
  }
}


initializeFirebase() async {
  await Firebase.initializeApp(options: const FirebaseOptions(apiKey: 'AIzaSyBb5e2j8blwx3WQFRFZ2POj8GmaKgQZ0EQ',
    appId: '1:864225195858:android:a1f6e78333db2aba82ec8b',
    messagingSenderId: '864225195858',
    projectId: 'chat-app-ff6a8',
    storageBucket: 'chat-app-ff6a8.appspot.com',));
}
