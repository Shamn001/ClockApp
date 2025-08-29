import 'package:flutter/material.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  bool isRunning=false;
  int hour=0;
  int min=0;
  int sec=0;
  final ValueNotifier<int> remainingSec=ValueNotifier<int> (0);
  Timer? timer;
  
  void startTimer(){
    int totalseconds=hour*3600 + min*60 + sec;
    remainingSec.value=totalseconds;
  }
  void stopTimer(){

  }
  void delete(){

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              SizedBox(
                height: 100,
                child: Row( mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(onPressed: (){
                      showMenu(
                        context: context,
                        position: RelativeRect.fromLTRB(100, 80, 0, 0),
                        color: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        items: [
                          PopupMenuItem(
                            value: 'add',
                            child: Text('Add preset timer',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400),)),
                          PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit preset timers')),
                          PopupMenuItem(
                            value: 'set',
                            child: Text('Settings'))
                        ]
                        ).then((value){
                          if(value!=null){
                            switch (value){
                              case 'add':
                              break;
                              case 'edit':
                              break;
                              case 'set':
                              break;
                            }
                          }
                        });
                      }, 
                    icon: Icon(Icons.more_vert))
                  ],
                ),
              ),
              SizedBox(
                height: 300,
                child: Center(
                  child: Row(
                    children: [
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 100,
                          physics: FixedExtentScrollPhysics(),
                           onSelectedItemChanged: (index) {
                             setState(() {
                               hour=index%24;
                             });
                           },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context , index){
                              final value=index%24;
                              return Text(value.toString().padLeft(2,'0'),
                              style: TextStyle(fontSize: 30,
                              color: hour==value?Colors.black:Colors.grey),);
                              }
                              )
                            ),
                      ),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 100,
                          physics: FixedExtentScrollPhysics(), 
                          onSelectedItemChanged: (index) {
                            setState(() {
                              min=index%60;
                            });
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context , index){
                              final value=index%60;
                              return Text(value.toString().padLeft(2,'0'),
                              style: TextStyle(fontSize: 30,color: min==value?Colors.black:Colors.grey),);
                              }
                              )
                            ),
                      ),
                      Text(':',style: TextStyle(fontSize: 30),),
                      Expanded(
                        child: ListWheelScrollView.useDelegate(
                          itemExtent: 100,
                          physics: FixedExtentScrollPhysics(), 
                          onSelectedItemChanged: (index) {
                            setState(() {
                              sec=index%60;
                            });                            
                          },
                          childDelegate: ListWheelChildBuilderDelegate(
                            builder: (context , index){
                              final value=index%60;
                              return Text(value.toString().padLeft(2,'0'),
                              style: TextStyle(
                                fontSize: 30,color: sec==value?Colors.black:Colors.grey),);
                              }
                              )
                            ),
                      )
                    ],
                  ),
                ),
              ),
              Row( mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(onPressed: delete,
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      minimumSize: Size(140, 52),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(24)),
                    ),
                    child: Text('Reset',
                    style:TextStyle(color:remainingSec.value==0 ? Colors.grey : Colors.black,
                    fontSize: 18))
                  ),
                  TextButton(onPressed: ()=>setState(() {
                    isRunning==false ? startTimer() : stopTimer();
                  }),
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
            ],
          ),
        )
      ),
    );
  }
}