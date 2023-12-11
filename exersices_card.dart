import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'goals_screen.dart';

class ExerciseLogScreen extends StatefulWidget {
  @override
  _ExerciseLogScreenState createState() => _ExerciseLogScreenState();
}

class _ExerciseLogScreenState extends State<ExerciseLogScreen> {
  // Simulated exercise progress
  double squatsProgress = 0.0;
  double deadliftsProgress = 0.0;
  double burpeesProgress = 0.0;

  // Number of movements for each exercise
  int squatsCount = 10;
  int deadliftsCount = 12;
  int burpeesCount = 8;

  // Timer variables
  bool squatsTimerRunning = false;
  int squatsTimerSeconds = 0;
  Timer? squatsTimer;

  bool deadliftsTimerRunning = false;
  int deadliftsTimerSeconds = 0;
  Timer? deadliftsTimer;

  bool burpeesTimerRunning = false;
  int burpeesTimerSeconds = 0;
  Timer? burpeesTimer;

  // Reload function
  void reloadProgress() {
    setState(() {
      squatsProgress = 0.0;
      deadliftsProgress = 0.0;
      burpeesProgress = 0.0;

      squatsTimerRunning = false;
      deadliftsTimerRunning = false;
      burpeesTimerRunning = false;

      squatsTimer?.cancel();
      deadliftsTimer?.cancel();
      burpeesTimer?.cancel();
    });
  }

  // Function to handle timer ticks
  void handleTimerTick(String exercise) {
    setState(() {
      switch (exercise) {
        case 'Squats':
          squatsTimerSeconds++;
          break;
        case 'Deadlifts':
          deadliftsTimerSeconds++;
          break;
        case 'Burpees':
          burpeesTimerSeconds++;
          break;
      }

      if (_isExerciseComplete(exercise)) {
        _stopTimer(exercise);
      }
    });
  }

  // Helper function to check if exercise is complete
  bool _isExerciseComplete(String exercise) {
    switch (exercise) {
      case 'Squats':
        return squatsProgress >= 1.0;
      case 'Deadlifts':
        return deadliftsProgress >= 1.0;
      case 'Burpees':
        return burpeesProgress >= 1.0;
      default:
        return false;
    }
  }

  // Helper function to stop the timer
  void _stopTimer(String exercise) {
    switch (exercise) {
      case 'Squats':
        squatsTimer?.cancel();
        squatsTimerRunning = false;
        break;
      case 'Deadlifts':
        deadliftsTimer?.cancel();
        deadliftsTimerRunning = false;
        break;
      case 'Burpees':
        burpeesTimer?.cancel();
        burpeesTimerRunning = false;
        break;
    }
  }

  // Exercise completion function
  void completeExercise(String exercise) {
    setState(() {
      switch (exercise) {
        case 'Squats':
          if (squatsProgress < 1.0) {
            squatsProgress += 0.1;
          } else {
            _stopTimer(exercise);
          }
          break;
        case 'Deadlifts':
          if (deadliftsProgress < 1.0) {
            deadliftsProgress += 0.1;
          } else {
            _stopTimer(exercise);
          }
          break;
        case 'Burpees':
          if (burpeesProgress < 1.0) {
            burpeesProgress += 0.1;
          } else {
            _stopTimer(exercise);
          }
          break;
      }
      _saveProgress();
    });
  }

  // Save progress using SharedPreferences
  Future<void> _saveProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('squatsProgress', squatsProgress);
    prefs.setDouble('deadliftsProgress', deadliftsProgress);
    prefs.setDouble('burpeesProgress', burpeesProgress);
  }

  // Load progress from SharedPreferences
  Future<void> _loadProgress() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      squatsProgress = prefs.getDouble('squatsProgress') ?? 0.0;
      deadliftsProgress = prefs.getDouble('deadliftsProgress') ?? 0.0;
      burpeesProgress = prefs.getDouble('burpeesProgress') ?? 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  @override
  void dispose() {
    squatsTimer?.cancel();
    deadliftsTimer?.cancel();
    burpeesTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exercise Log'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: reloadProgress,
          ),
          IconButton(
            icon: Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GoalsScreen(
                    squatsCompletion: squatsProgress,
                    deadliftsCompletion: deadliftsProgress,
                    burpeesCompletion: burpeesProgress,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ExerciseCard(
                exerciseName: 'Squats',
                progress: squatsProgress,
                count: squatsCount,
                timerRunning: squatsTimerRunning,
                timerSeconds: squatsTimerSeconds,
                onBegin: () {
                  setState(() {
                    squatsTimerRunning = !squatsTimerRunning;
                    if (squatsTimerRunning) {
                      squatsTimer =
                          Timer.periodic(Duration(seconds: 1), (timer) {
                        handleTimerTick('Squats');
                      });
                    } else {
                      _stopTimer('Squats');
                    }
                  });
                },
                onComplete: () {
                  completeExercise('Squats');
                },
              ),
              SizedBox(height: 16.0),
              ExerciseCard(
                exerciseName: 'Deadlifts',
                progress: deadliftsProgress,
                count: deadliftsCount,
                timerRunning: deadliftsTimerRunning,
                timerSeconds: deadliftsTimerSeconds,
                onBegin: () {
                  setState(() {
                    deadliftsTimerRunning = !deadliftsTimerRunning;
                    if (deadliftsTimerRunning) {
                      deadliftsTimer =
                          Timer.periodic(Duration(seconds: 1), (timer) {
                        handleTimerTick('Deadlifts');
                      });
                    } else {
                      _stopTimer('Deadlifts');
                    }
                  });
                },
                onComplete: () {
                  completeExercise('Deadlifts');
                },
              ),
              SizedBox(height: 16.0),
              ExerciseCard(
                exerciseName: 'Burpees',
                progress: burpeesProgress,
                count: burpeesCount,
                timerRunning: burpeesTimerRunning,
                timerSeconds: burpeesTimerSeconds,
                onBegin: () {
                  setState(() {
                    burpeesTimerRunning = !burpeesTimerRunning;
                    if (burpeesTimerRunning) {
                      burpeesTimer =
                          Timer.periodic(Duration(seconds: 1), (timer) {
                        handleTimerTick('Burpees');
                      });
                    } else {
                      _stopTimer('Burpees');
                    }
                  });
                },
                onComplete: () {
                  completeExercise('Burpees');
                },
              ),
              // Add more exercises as needed
            ],
          ),
        ),
      ),
    );
  }
}

class ExerciseCard extends StatelessWidget {
  final String exerciseName;
  final double progress;
  final int count;
  final bool timerRunning;
  final int timerSeconds;
  final VoidCallback onBegin;
  final VoidCallback onComplete;

  ExerciseCard({
    required this.exerciseName,
    required this.progress,
    required this.count,
    required this.timerRunning,
    required this.timerSeconds,
    required this.onBegin,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      elevation: 4.0,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              '$exerciseName x$count',
              style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            SizedBox(height: 12.0),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
            SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: timerRunning ? onComplete : onBegin,
              style: ElevatedButton.styleFrom(
                primary: Colors.purple,
                onPrimary: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              child: Text(timerRunning ? 'Complete' : 'Begin'),
            ),
            SizedBox(height: 12.0),
            Text(
              'Time: ${timerSeconds ~/ 60}:${(timerSeconds % 60).toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 16.0, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
