import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class Timepick extends StatefulWidget {

  final int? index;

  const Timepick({super.key,this.index});

  @override
  State<Timepick> createState() => _TimepickState();
}

class _TimepickState extends State<Timepick> {

  late Box alarmBox;

  int hour=0;
  int min=0;
  int tme=0;
  List<String> dayTme=['am','pm'];

  late FixedExtentScrollController hourController;
  late FixedExtentScrollController minController;
  late FixedExtentScrollController tmeController;

  @override
  void initState(){
    super.initState();
    alarmBox=Hive.box('alarms');
    if(widget.index!=null){
      List alarms=alarmBox.get('alarms',defaultValue: []);
      var time=alarms[widget.index!]['time'];
      hour=int.parse(time.split(':')[0]);
      min=int.parse(time.split(':')[1]);
      tme= alarms[widget.index!]['format']=='am'? 0 :1;
    }
    hourController=FixedExtentScrollController(initialItem: hour);
    minController=FixedExtentScrollController(initialItem: min);
    tmeController=FixedExtentScrollController(initialItem: tme);
  }

  void addTime(){
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
  updateTime(){
    List alarms=alarmBox.get('alarms');

    alarms[widget.index!]={
      'time':'${hour.toString().padLeft(2,'0')}:${min.toString().padLeft(2,'0')}',
      'status':true,
      'format':dayTme[tme]
    };
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
                        controller: hourController,
                        itemExtent: 100,
                        physics: FixedExtentScrollPhysics(),
                        onSelectedItemChanged: (index) {
                          setState(() {
                            hour=index%24;
                          });
                        },
                        childDelegate: ListWheelChildBuilderDelegate(
                        builder: (context , index){
                          final value=index%12;
                          return Text(value.toString().padLeft(2,'0'),
                          style: TextStyle(fontSize: 30,
                          color: hour==value?Colors.black:Colors.grey),);
                        }
                        )
                      ),
                    ),
                    Expanded(
                      child: ListWheelScrollView.useDelegate(
                        controller: minController,
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
                        controller: tmeController,
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
                onPressed: widget.index==null ? addTime : updateTime, 
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