import 'package:flutter/material.dart';

class GoalsScreen extends StatefulWidget {
  final double squatsCompletion;
  final double deadliftsCompletion;
  final double burpeesCompletion;

  GoalsScreen({
    required this.squatsCompletion,
    required this.deadliftsCompletion,
    required this.burpeesCompletion,
  });

  @override
  _GoalsScreenState createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Goals'),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.black],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GoalCircularProgressIndicator(
                  label: 'Squats',
                  completion: widget.squatsCompletion,
                ),
                SizedBox(height: 16.0),
                GoalCircularProgressIndicator(
                  label: 'Deadlifts',
                  completion: widget.deadliftsCompletion,
                ),
                SizedBox(height: 16.0),
                GoalCircularProgressIndicator(
                  label: 'Burpees',
                  completion: widget.burpeesCompletion,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GoalCircularProgressIndicator extends StatelessWidget {
  final String label;
  final double completion;

  GoalCircularProgressIndicator({
    required this.label,
    required this.completion,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 150.0,
                  height: 150.0,
                  child: CircularProgressIndicator(
                    value: completion,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  ),
                ),
                Text(
                  '${(completion * 100).toInt()}%',
                  style: TextStyle(fontSize: 20.0, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 8.0),
            Text(
              '$label - ${(completion * 100).toInt()}% Complete',
              style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
