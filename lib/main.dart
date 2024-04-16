import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:password_note/note_data.dart';
import 'home.dart';
import 'hive.dart';

void main() async {
  await hiveInit();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const title = '密码本子';

    // final noteData = NoteData.getInstance();

    return ChangeNotifierProvider(
      create: (context) => AppData(),
      child: MaterialApp(
        title: title,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
          ),
        ),
        home: const HomePage(title: title),
      ),
    );
  }
}
