import 'package:clock1/screens/timepick.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'package:alarm/alarm.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Timer? alarmTimer;
  AudioPlayer audioPlayer=AudioPlayer();
  late Box alarmBox;

  DateTime parseTime(String timeStr, String format) {
  final parts = timeStr.split(':');
  int hour = int.parse(parts[0]);
  final minute = int.parse(parts[1]);
  final fmt = format.toLowerCase();

  // Convert to 24-hour
  if (fmt == 'pm' && hour != 12) hour += 12;
  if (fmt == 'am' && hour == 12) hour = 0;

  final now = DateTime.now();
  var scheduled = DateTime(now.year, now.month, now.day, hour, minute);

  // If the time is already past, schedule for tomorrow
  if (!scheduled.isAfter(now)) {
    scheduled = scheduled.add(const Duration(days: 1));
  }

  return scheduled;
}


@override
void initState() {
  super.initState();
  alarmBox = Hive.box('alarms');

  if (alarmBox.get('alarms') == null) {
    alarmBox.put('alarms', []);
  }

  Alarm.ringStream.stream.listen((AlarmSettings alarmSettings) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(DateFormat('hh:mm a').format(alarmSettings.dateTime)),
        content: const Text('Alarm!'),
        actions: [
          TextButton(
            onPressed: () async {
              await Alarm.stop(alarmSettings.id);
              Navigator.pop(context);
            },
            child: const Text('Stop'),
          ),
        ],
      ),
    );
  });
}


  @override
  void dispose(){
    alarmTimer?.cancel();
    super.dispose();
  }

  Future<void> scheduleAlarm(int id,DateTime dateTime) async{
    final alarmSettings= AlarmSettings(
      id: id, dateTime: dateTime, 
      assetAudioPath: 'assets/alarm.mp3', 
      volumeSettings: VolumeSettings.fade(fadeDuration: Duration(seconds: 3)),
      loopAudio: true,
      androidFullScreenIntent: true,
      notificationSettings: NotificationSettings(title: 'alarm', body: 'body')
    );
    await Alarm.set(alarmSettings: alarmSettings);
  }

  Future<void> cancelAlarm(int id) async{
    await Alarm.stop(id);
    setState(() {});
  }

  void deleteAlarm( index) async{
    List alarms = alarmBox.get('alarms');
    final id=alarms[index]['id'];
    await cancelAlarm(id);
    alarms.removeAt(index);
    alarmBox.put('alarms', alarms);
    setState(() {
    });
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
                        onTap: ()async{
                          await Navigator.push( context,
                            MaterialPageRoute(builder: (context)=>Timepick(index: index))
                          );
                          setState(() {});
                        },
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
                              
                              onChanged:(value)async{
                                setState(() {
                                  alarm['status']=value;
                                  alarmBox.put('alarms',alarms);
                                });
                                if(value){
                                  final alarmTime=parseTime(alarm['time'],alarm['format']);
                                  await scheduleAlarm(alarm['id'],alarmTime);
                                }
                                else{
                                  cancelAlarm(alarm['id']);
                                }
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