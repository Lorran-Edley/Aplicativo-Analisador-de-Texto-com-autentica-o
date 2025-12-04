import 'package:flutter/material.dart';
import '../views/tela_login.dart';
import '../services/database_service.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Analisador de Texto',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
      home: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return const TelaLogin();
        },
      ),
      debugShowCheckedModeBanner: false,
    );
  }

  Future<void> _initializeApp() async {
    // Inicializa o banco de dados
    await DatabaseService().database;
  }
}
