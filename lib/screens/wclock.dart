import 'dart:async';
import 'package:clock1/services/time.dart';
import 'package:flutter/material.dart';

class Wclock extends StatefulWidget {
  const Wclock({super.key});

  @override
  State<Wclock> createState() => _WclockState();
}

class _WclockState extends State<Wclock> {
  String? time;
  String? timezone;
  bool isLoading = true;
  
  Timer? timer;

  @override
  void initState() {
    super.initState();
    loadTime(); // fetch once immediately
    // then refresh from API every second
    timer = Timer.periodic(const Duration(seconds: 1), (_) => loadTime());
  }

  Future<void> loadTime() async {
    try {
      final data = await TimeService().fetchTime();
      if (!mounted) return;
      setState(() {
        time = data["time"];
        timezone = data["timezone"];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        time = "Error fetching time";
        timezone = "";
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: 300,
            child: Center(
              child: isLoading
                  ? const CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          time ?? "N/A",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          timezone ?? "",
                          style: const TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
            ),
          ),
          
        ],
      ),
    );
  }
}
