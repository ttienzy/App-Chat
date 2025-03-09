import 'package:f1/auth/projects_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:f1/auth/auth_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:f1/firebase/firebase_options.dart';
import 'package:f1/routers/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    name: 'f1',
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthNotifier(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider(create: (_) => ProjectProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final router = configureRouter(authNotifier);

    return MaterialApp.router(
      routerConfig: router,
      title: 'Chat App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto', // bạn có thể dùng Google Fonts hoặc font khác
      ),
    );
  }
}
