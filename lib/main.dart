import 'package:dietplanner/screens/auth_screen.dart';
import 'package:dietplanner/screens/goals_screen.dart';
import 'package:dietplanner/screens/splash_screen.dart';
import 'package:dietplanner/screens/meal_builder_screen.dart';
import 'package:dietplanner/screens/logs_screen.dart';
import 'package:dietplanner/screens/progress_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diet Planner',
      theme: ThemeData(primarySwatch: Colors.deepOrange),

      routes: {
        '/meal': (context) => const BuildMealScreen(),
        '/progress': (context) => const ProgressScreen(),
        '/goals': (context) => const GoalsScreen(),
        '/logs': (context) => const LogsScreen(),
      },

      home: const SplashScreen(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const GoalsScreen();
        }
        return const AuthScreen();
      },
    );
  }
}
