import 'package:flutter/material.dart';
import 'package:todo_app/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/services/task_state.dart';
import './constants/themes.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TaskState(),
      child: MaterialApp(
        title: 'Todo App',
        debugShowCheckedModeBanner: false,
        home: const HomeScreen(),
        theme: lightTheme,
      ),
    );
  }
}
