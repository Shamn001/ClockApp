import 'dart:async';
import 'package:flutter/material.dart';

class TimerScreen extends StatefulWidget {
  const TimerScreen({super.key});

  @override
  State<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends State<TimerScreen> {
  bool isRunning = false;
  int min = 0;
  int sec = 0;
  int ms = 0; // milliseconds (0–999)

  final ValueNotifier<int> remainingMs = ValueNotifier<int>(0);
  Timer? timer;

  void startTimer() {
    int totalMilliseconds = (min * 60 * 1000) + (sec * 1000) + ms;
    remainingMs.value = totalMilliseconds;
    isRunning = true;

    timer = Timer.periodic(const Duration(milliseconds: 10), (t) {
      if (remainingMs.value <= 0) {
        stopTimer();
      } else {
        remainingMs.value -= 10;
      }
    });
  }

  void stopTimer() {
    timer?.cancel();
    isRunning = false;
    setState(() {});
  }

  void resetTimer() {
    stopTimer();
    remainingMs.value = 0;
    min = 0;
    sec = 0;
    ms = 0;
    setState(() {});
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 50),
              SizedBox(
                height: 250,
                child: Center(
                  child: Row(
                    children: [
                      // Minutes
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 60,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              min = index % 60;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              final value = index % 60;
                              return Text(
                                value.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 28,
                                  color: min == value ? Colors.black : Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                        child: Text(':', style: TextStyle(fontSize: 28)),
                      ),
                      // Seconds
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 60,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              sec = index % 60;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              final value = index % 60;
                              return Text(
                                value.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 28,
                                  color: sec == value ? Colors.black : Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 60,
                        child: Text(':', style: TextStyle(fontSize: 28)),
                      ),
                      // Milliseconds (0–99 for readability)
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 60,
                          physics: const FixedExtentScrollPhysics(),
                          onSelectedItemChanged: (index) {
                            setState(() {
                              ms = (index % 100) * 10; // steps of 10ms
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context, index) {
                              final value = (index % 100) * 10;
                              return Text(
                                value.toString().padLeft(2, '0'),
                                style: TextStyle(
                                  fontSize: 28,
                                  color: ms == value ? Colors.black : Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ValueListenableBuilder<int>(
                valueListenable: remainingMs,
                builder: (context, value, child) {
                  final minutes = (value ~/ 60000).toString().padLeft(2, '0');
                  final seconds = ((value ~/ 1000) % 60).toString().padLeft(2, '0');
                  final milli = ((value % 1000) ~/ 10).toString().padLeft(2, '0');
                  return Text(
                    "$minutes:$seconds:$milli",
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                  );
                },
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: resetTimer,
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      minimumSize: const Size(120, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Reset',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isRunning ? stopTimer() : startTimer();
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: isRunning
                          ? Colors.redAccent
                          : const Color.fromARGB(203, 67, 40, 243),
                      minimumSize: const Size(120, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      isRunning ? 'Stop' : 'Start',
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
