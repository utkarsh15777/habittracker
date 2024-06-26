import 'package:flutter/material.dart';
import 'package:habittracker/database/habbit_database.dart';
import 'package:habittracker/pages/home_page.dart';
import 'package:habittracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await HabbitDatabase.initialize();
  await HabbitDatabase().saveFirstLaunchDate();
  runApp(
    MultiProvider(providers: 
      [
        ChangeNotifierProvider(
          create :(context) => HabbitDatabase(),
        ),
        ChangeNotifierProvider(
          create :(context) => ThemeProvider(),
          child: const MyApp(),
        )
      ],
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const HomePage()
    );
  }
}

