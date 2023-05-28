import 'dart:async';

import 'package:coworkers/src/canil/feats/add/presentation/view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:sentry_logging/sentry_logging.dart';

void main() async {
  // BindingBase.debugZoneErrorsAreFatal = true;
  runZonedGuarded(() async {
    SentryFlutter.init(
      (options) {
        options.dsn = kDebugMode
            ? 'https://1072bc02b66c4fff9daf72a04e891d8a@o4505183398068224.ingest.sentry.io/4505245143662592'
            : 'https://2efa912c89be4d4b9274586d0757fb2f@o4505183398068224.ingest.sentry.io/4505245155459072';
        // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
        // We recommend adjusting this value in production.
        options.tracesSampleRate = kDebugMode ? 1.0 : 0.3;
        options.addIntegration(LoggingIntegration());
      },
      appRunner: () async {
        WidgetsFlutterBinding.ensureInitialized();
        await Firebase.initializeApp(
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
      },
    );
  }, (exception, stackTrace) async {
    debugPrint("Ocorreu uma exception: $exception");
    Sentry.captureException(exception, stackTrace: stackTrace);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
