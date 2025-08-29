import 'package:clock1/screens/timepick.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Timer? alarmTimer;
  AudioPlayer audioPlayer=AudioPlayer();
  late Box alarmBox;

  @override
  void initState(){
    super.initState();
    alarmBox=Hive.box('alarms');
    if(alarmBox.get('alarms')==null){
      alarmBox.put('alarms',[{'time':'00:00','status':false,'format':'am'}]);
    }

    alarmTimer=Timer.periodic(Duration(seconds:1), (timer){
      checkAlarm();
    }
    );
  }

  @override
  void dispose(){
    alarmTimer?.cancel();
    super.dispose();
  }

  void updateStatus(int index,bool value){
    List alarms=alarmBox.get('alarms');
    alarms[index]['status']=value;
    alarmBox.put('alarms',alarms);
    setState(() {});
  }
  void deleteAlarm( index){
    List alarms = alarmBox.get('alarms');
    alarms.removeAt(index);
    alarmBox.put('alarms', alarms);
    setState(() {
    });
  }
  void checkAlarm(){
    List alarms=alarmBox.get('alarms');
    String currentTime=DateFormat('hh:mm').format(DateTime.now());
    String currentFormat=DateFormat('a').format(DateTime.now()).toLowerCase();

    for(var alarm in alarms){
      if(
        alarm['status']==true&&
        alarm['time']==currentTime&&
        alarm['format']==currentFormat
        ){
          alarm['status']=false;
          var time=alarm['time'];
          ringAlarm(time);
        }
    }
  }
  void ringAlarm(time)async{
    await audioPlayer.play(AssetSource('alarm.mp3'));
    showDialog(
      context: context, 
      builder: (_)=>AlertDialog(
        title: Text(time),
        content: Text('Alarm'),
        actions: [
          TextButton(
            onPressed: (){
              audioPlayer.stop();
              Navigator.pop(context);
              }, 
            child: Text('Stop'))
        ],
      ));
  }

  @override
  Widget build(BuildContext context) {

    List alarms=alarmBox.get('alarms');

    return Scaffold(backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              
              height: 280,
              child: Center(
                child: Text(alarms.any((alarm)=>alarm['status']==true)
              ?'Next alarm ${alarms.firstWhere((a)=>a['status']==true)['time']}'
              : 'All alarms are off',style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30
              ),)),

            ),
            SizedBox(
              height: 36,
              child: Row( mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () async {
                      await Navigator.push(context, MaterialPageRoute(
                        builder: (context)=>Timepick()
                      )
                      );
                      setState(() {});
                      },
                    child: Icon(Icons.add,size: 34,)),
                  Icon(Icons.more_vert_rounded,size: 34,)
                ],
              ),
            ),
              Expanded(
                child: ListView.builder(
                  itemCount: alarms.length,
                  itemBuilder: (context,index){
                    var alarm=alarms[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 4),
                    child: Material(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      child: InkWell(
                        onTap: ()=>Navigator.push( context,
                        MaterialPageRoute(builder: (context)=>Timepick())
                        ),
                      onLongPress: () async {
                        final result = await showModalBottomSheet<String>(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                          ),
                          builder: (context) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit_outlined, size: 28, color: Colors.black),
                                    onPressed: () {
                                      Navigator.pop(context, 'edit');
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline, size: 28, color: Colors.black),
                                    onPressed: () {
                                      Navigator.pop(context, 'delete');
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      
                        if (result == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Timepick()),
                                                );
                        } else if (result == 'delete') {
                          deleteAlarm(index);
                        }
                      },

                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        decoration: BoxDecoration(border: BorderDirectional()),
                        height: 120,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 12),
                          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        
                          children: [
                            
                            Row(
                              children: [
                                Text(alarm['time'],style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30
                                ),),
                              
                                Text(alarm['format'],style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                              ),),
                            ],
                            ),
                            Transform.scale(
                              scale: 0.7,
                              child: Switch(
                                
                                value: alarm['status'],
                                activeColor: Colors.white,
                                activeTrackColor:  Colors.deepPurple,
                                inactiveThumbColor: Colors.white,
                              
                              onChanged:(value){
                                setState(() {
                                  updateStatus(index, value);
                                });
                              } ),
                            )
                          ],
                        ),
                        ),
                      ),
                    ),
                  ),
                );}),
            )
          ],
        ),
      ),
    );
  }
}