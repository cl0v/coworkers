import 'package:coworkers/src/canil/feats/add/presentation/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAcAgXbMZZo5L6yeSa3a3y7TBy12IcAgmY",
      appId: "1:1024413198026:web:435ed4541a2446da797633",
      messagingSenderId: "1024413198026",
      projectId: "dreampuppy-12951",
      authDomain: "dreampuppy-12951.firebaseapp.com",
      measurementId: "G-QYCH3WSN61",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coworkers DreamPuppy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: CodePage(),
    );
  }
}

class CodePage extends StatelessWidget {
  CodePage({super.key});

  final TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 200,
          child: TextField(
            decoration: const InputDecoration(hintText: 'Código de login'),
            onChanged: (code) => code.length == 6 && code == "0luis0"
                ? Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AddCanilPage()))
                : null,
          ),
        ),
      ),
    );
  }
}
