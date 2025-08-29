import 'dart:async';

import 'package:flutter/material.dart';

class Swatch extends StatefulWidget {
  const Swatch({super.key});

  @override
  State<Swatch> createState() => _SwatchState();
}

class _SwatchState extends State<Swatch> {

  bool isRunning=false;
  final ValueNotifier<int> seconds=ValueNotifier<int>(0);
  Timer? timer;

  void timerstart(){
    timer=Timer.periodic(Duration(seconds: 1), (_){
      seconds.value++;
      setState(() {
        isRunning=true;
      });
    });
  }
  void stopTimer(){
    setState(() {
      timer?.cancel();
      isRunning=false;
    });
    
  }
  void resetTimer(){
    timer?.cancel();
    setState(() {
      seconds.value=0;
      isRunning=false;
    });
  }
  String formateTime(int seconds){
    final int min=seconds~/60;
    final int sec=seconds%60;
    final String ss=sec.toString().padLeft(2,'0');
    final String mm=min.toString().padLeft(2,'0');
    return '$mm:$ss';
  }
  @override
  void dispose(){
    timer?.cancel();
    seconds.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(child: Center(
              child: ValueListenableBuilder(
                valueListenable: seconds,
                builder: (context, value, child) {
                  return Text(formateTime(value),
                              style: TextStyle(fontSize: 30),);
                }
              ))),
              Expanded(
                child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: resetTimer,
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      minimumSize: Size(140, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(24)),
                    ),
                    child: Text('Reset',
                    style:TextStyle(color:seconds.value==0 ? Colors.grey : Colors.black,
                    fontSize: 18))
                  ),
                  TextButton(onPressed: (){
                    isRunning ? stopTimer(): timerstart();
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: isRunning==false? Color.fromARGB(203, 67, 40, 243) : Colors.redAccent,
                    minimumSize: Size(140, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(24)),
                  ),
                  child: Text(isRunning==false ? 'Start':'Stop',
                  style: TextStyle(color: Colors.white,
                  fontSize: 18),),
                  ),
                  
                ],
                ),
            ),
          ],
        ),
      ),
      
    );
  }
}