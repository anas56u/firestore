import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:studyf1/crude.dart';

Future<void> main() async {
  //It is a line used to ensure that the widget hook in Flutter applications is configured correctly before performing any operations that require that configuration.
  //WidgetsBinding: This is the bridge between the Flutter framework and the underlying platform. It's like a conductor in an orchestra, ensuring all parts of the app work together smoothly.
//ensureInitialized(): This method makes sure that the Flutter framework is completely set up before you start using it. It's like priming a pump before using it to draw water.
  WidgetsFlutterBinding.ensureInitialized();
  //This line is used to initialize Firebase in the application. Firebase is a collection of tools and services provided by Google for mobile and web. By configuring Firebase initially, it expects the possibility of connecting to different Firebases
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Crude() ,
    );
  }
}
