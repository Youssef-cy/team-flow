import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';

class Details extends StatefulWidget {
  const Details({super.key});

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  //background colors
  //todo: replace color1 with task background in home page
  Color color1 = Colors.deepPurple;
  Color color2 = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color1,
        centerTitle: true,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 70.0),
              // todo: replace tname with task name
              child: Text("tname", style: TextStyle(fontSize: 27)),
            ),
            Spacer(),
            GestureDetector(
              onTap: () => PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(child: Text("edit"), value: "edit"),
                  PopupMenuItem(
                    child: Text("delete", style: TextStyle(color: Colors.red)),
                    value: "delete",
                  ),
                ],
              ),

              child: Icon(Icons.more_vert),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Container(
          height: double.infinity,
          width: 400,
          decoration: BoxDecoration(
            //background colors
            gradient: LinearGradient(
              colors: [color1, color2],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //todo: replace text with task discription
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 20),
                child: SizedBox(
                  width: 330,
                  child: Text(
                    "discription of task ",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text("Made by ", style: TextStyle(fontSize: 25)),
                  ),
                  //todo:replace background colors with photo of user
                  CircleAvatar(backgroundColor: color1),
                ],
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsetsGeometry.only(left: 20),
                    child: Text(
                      "team members ",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  //todo: replace with photos
                  Container(
                    child: Stack(
                      children: [
                        CircleAvatar(backgroundColor: color1),

                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: CircleAvatar(backgroundColor: Colors.amber),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 38.0),
                          child: CircleAvatar(backgroundColor: color1),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0, right: 30),
                  child: Text("your tasks", style: TextStyle(fontSize: 25)),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0, left: 15),
                child: Container(
                  width: 330,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SizedBox(
                          height: 40,

                          child: Text(
                            "text discription ",
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(child: Text("edit"), value: "edit"),
                          PopupMenuItem(
                            child: Text(
                              "delete",
                              style: TextStyle(color: Colors.red),
                            ),
                            value: "delete",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
