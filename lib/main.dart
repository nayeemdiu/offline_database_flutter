import 'package:databaseoffline/Page/HomePage.dart';
import 'package:flutter/material.dart';

import 'Database/DataBase_Helper.dart';

Future<void> main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

