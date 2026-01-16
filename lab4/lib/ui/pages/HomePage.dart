import 'package:flutter/material.dart';
import 'package:lab4/ui/widgets/ContainerLibraries.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF6F6F8),
        elevation: 0,
        title: const Text('Lab 4 – Flutter UI Fundamental'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: const [
            ExerciseCard(line1: 'Exercise 1 – Core Widgets', line2: 'Demo'),
            SizedBox(height: 12),
            ExerciseCard(line1: 'Exercise 2 – Input Controls', line2: 'Demo'),
            SizedBox(height: 12),
            ExerciseCard(line1: 'Exercise 3 – Layout Demo', line2: 'Demo'),
            SizedBox(height: 12),
            ExerciseCard(line1: 'Exercise 4 – App Structure & Theme', line2: 'Theme'),
            SizedBox(height: 12),
            ExerciseCard(line1: 'Exercise 5 – Common UI Fixes', line2: 'Fixes'),
          ],
        ),
      ),
    );
  }
}
