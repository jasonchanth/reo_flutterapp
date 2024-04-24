import 'package:flutter/material.dart';
import 'package:helpdesk_demo/PollingStation.dart';
import 'package:helpdesk_demo/PollingStationDetailsPage.dart';

//import 'package:flutter_to_do_list/const/colors.dart';
//import 'package:flutter_to_do_list/data/firestor.dart';
//import 'package:flutter_to_do_list/model/notes_model.dart';
//import 'package:flutter_to_do_list/screen/edit_screen.dart';

class Task_Widget_bk extends StatefulWidget {
  String _note;

  Task_Widget_bk(this._note, {super.key});

  @override
  State<Task_Widget_bk> createState() => _Task_WidgetState_bk();
}

class _Task_WidgetState_bk extends State<Task_Widget_bk> {
  @override
  Widget build(BuildContext context) {
    bool isDone = false;
    return Scaffold(
      appBar: AppBar(
        title: Text('選舉事務'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),

          //padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              // image
              imageee(),
              SizedBox(width: 15),
              // title and subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "title",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Checkbox(
                          activeColor: Colors.green,
                          value: isDone,
                          onChanged: (value) {
                            setState(() {
                              isDone = !isDone;
                            });
                            // Firestore_Datasource()
                            //   .isdone(widget._note.id, isDone);
                          },
                        )
                      ],
                    ),
                    Text(
                      "widget._note.subtitle",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.grey.shade400),
                    ),
                    // Spacer(),
                    //åedit_time()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageee() {
    return Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        image: DecorationImage(
          image: AssetImage('assets/loginpage_poster.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
