import 'package:flutter/material.dart';
import 'package:untitled/presentation/screens/registerForm/register_form_stage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegistrationForm(),
    );
  }
}
