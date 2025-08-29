import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Timepick extends StatefulWidget {
  const Timepick({super.key});

  @override
  State<Timepick> createState() => _TimepickState();
}

class _TimepickState extends State<Timepick> {

  late Box alarmBox;

  int hour=0;
  int min=0;
  int tme=0;
  List<String> dayTme=['am','pm'];

  @override
  void initState(){
    super.initState();
    alarmBox=Hive.box('alarms');
  }

  void saveTime(){
    Map<String, Object> result={
      'time':'${hour.toString().padLeft(2,'0')}:${min.toString().padLeft(2,'0')}',
      'status':true,
      'format':dayTme[tme]
      };

    List alarms=alarmBox.get('alarms',defaultValue: []);

    alarms.add(result);

    alarmBox.put('alarms', alarms);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SizedBox(
                height: 300,
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
                          style: TextStyle(fontSize: 30,
                          color: min==value?Colors.black:Colors.grey),);
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
                            tme=index;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context , index){
                          final value=dayTme[index];
                          return Text(value,
                          style: TextStyle(fontSize: 30,
                          color: tme==index?Colors.black:Colors.grey),);
                        },
                        childCount: dayTme.length
                        )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Row(
          children: [
            Expanded(
              child: TextButton(onPressed: (){
                Navigator.pop(context);
              }, child: Text('Cancel',
              style: TextStyle(
                color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),))
            ),
            Expanded(
              child: TextButton(
                onPressed: saveTime, 
                child: Text('Save',
                style: TextStyle(
                color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold)))
            ),
          ],

        ),
      ),
    );
  }
}