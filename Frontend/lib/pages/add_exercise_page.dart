import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'set_exercise_page.dart';

class AddExercisePage extends StatefulWidget {
  @override
  State createState() => AddExercisePageState();
}

class AddExercisePageState extends State<AddExercisePage> {
  bool _isEmptyList = false;
  bool _isSearching = false;
  List<String> _exercisesList = [
    "Soulevé de Terre",
    "Squat",
    "Tractions",
    "Développé couché",
    "Rowing",
    "Dips",
    "Développé épaule",
    "Tirage vertical",
    "Tirage horizontal",
    "Extension lombaire",
    "Pullover",
    "Développés incliné",
    "Développés décliné",
    "Crunch",
    "Gainage",
    "Élévation latérale",
    "Élévation frontale",
    "Leg extension",
    "Hack squat",
    "Presse à cuisse",
    "Curls à la barre",
    "Pompes",
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      //key: globalKey,
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            color: Colors.white,
            onPressed: _isSearching
                ? () => setState(() {
                      _isSearching = false;
                    })
                : () => Navigator.of(context).pop(),
          ),
          title: _isSearching
              ? TextField(
                  autofocus: true,
                  cursorColor: DarkColor,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Rechercher un exercice...",
                    hintStyle: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Calibri',
                        color: Colors.white70),
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18
                  ),
                )
              : Text("Nouvel exercice"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.search),
                color: Colors.white,
                onPressed: () {
                  setState(() {
                    _isSearching = true;
                  });
                }),
          ],
          backgroundColor: PrimaryColor,
        ),
      body: Container(
        //color: Colors.green,
        child: Stack(
          children: <Widget>[
            Center(
              child: Visibility(
                visible: _isEmptyList,
                child: Text(
                  "Aucun exercice trouvé.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18, fontFamily: 'Calibri', color: Colors.grey),
                ),
              ),
            ),
            Container(
              //color: Colors.transparent,
              child: Form(
                child: Column(
                  children: <Widget>[
                    Visibility(
                      visible: !_isEmptyList,
                      child: Expanded(
                        child: Container(
                          //color: Colors.indigo,
                          child: ListView(
                            children: <Widget>[
                              for (final item in _exercisesList)
                                ListTile(
                                  key: ValueKey(item),
                                  leading: Icon(Icons.add),
                                  title: Text(item),
                                  onTap: () => Navigator.of(context).push(
                                      CupertinoPageRoute(
                                          builder: (BuildContext context) =>
                                              SetExercisePage(item))),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
