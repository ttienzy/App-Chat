import 'package:f1/auth/messages_notifier.dart';
import 'package:f1/auth/projects_notifier.dart';
import 'package:f1/auth/rooms_notifier.dart';
import 'package:f1/auth/tasks_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:f1/auth/auth_notifier.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:f1/firebase/firebase_options.dart';
import 'package:f1/routers/app_router.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  String? apiKey = dotenv.env['GOOGLE_API_KEY'];
  Gemini.init(apiKey: apiKey ?? 'API not available');

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
        ChangeNotifierProvider(create: (_) => RoomsProvider()),
        ChangeNotifierProvider(create: (_) => MessagesProvider()),
        ChangeNotifierProvider(create: (_) => TasksProvider()),
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
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto', // bạn có thể dùng Google Fonts hoặc font khác
      ),
    );
  }
}
