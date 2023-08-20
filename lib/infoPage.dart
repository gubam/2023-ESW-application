import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class infoPage extends StatefulWidget {
  const infoPage({Key? key}) : super(key: key);

  @override
  State<infoPage> createState() => _infoPageState();
}

DatabaseReference ref = FirebaseDatabase.instance.ref();

var butts;
Future getNumberButts() async{
  final numberButts = await ref.child("numberButts").get();
  butts  = numberButts.value;
}

class _infoPageState extends State<infoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Color(0xff9AC5F4),
          title: Text("information"),
        actions: [
          IconButton(onPressed: (){
            setState(() {
              getNumberButts();
            });
          }, icon: Icon(Icons.autorenew)),
        ],
      
      ),
        
        
        
        body:ListView(
          padding: EdgeInsets.symmetric(horizontal: 30,vertical: 50),
          children: [
            Row(
              children: [
              Text("담은 꽁초 갯수: ${butts}",style: TextStyle(fontSize: 20),),

            ],)
          ],
        ),

    );
  }
}
