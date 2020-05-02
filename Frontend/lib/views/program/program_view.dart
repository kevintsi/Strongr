import 'package:flutter/material.dart';
import 'package:strongr/utils/screen_size.dart';
import 'package:strongr/utils/strongr_colors.dart';
import 'package:strongr/widgets/strongr_rounded_container.dart';
import 'package:strongr/widgets/strongr_text.dart';

class ProgramView extends StatefulWidget {
  final String id;
  final String name;

  ProgramView({this.id, this.name});

  @override
  _ProgramViewState createState() => _ProgramViewState();
}

class _ProgramViewState extends State<ProgramView> {
  String weekday;
  bool isEditMode;

  Container buildListViewItem(int i) {
    return Container(
      margin: i == 1 ? EdgeInsets.only(top: 5) : null,
      key: ValueKey(i),
      padding: EdgeInsets.all(5),
      height: 90,
      child: StrongrRoundedContainer(
        width: ScreenSize.width(context),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              // color: Colors.yellow,
              width: 50,
              child: Center(
                child: StrongrText(
                  getShortWeekDay(i),
                  bold: true,
                ),
              ),
            ),
            Flexible(
              child: Container(
                // color: Colors.red,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Icon(Icons.accessibility),
                        ),
                        Flexible(
                          child: Container(
                            // color: Colors.blue,
                            child: StrongrText(
                              "Full body",
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Icon(Icons.fitness_center),
                        ),
                        Container(
                          width: 185,
                          child: StrongrText(
                            "4 exercices",
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isEditMode,
              child: Container(
                width: 35,
                child: RawMaterialButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.close,
                    color: Colors.red[800],
                  ),
                  shape: CircleBorder(),
                ),
              ),
            ),
            Visibility(
              visible: !isEditMode,
              child: Container(
                width: 35,
                height: 35,
                child: FloatingActionButton(
                  elevation: 0,
                  heroTag: "play_fab_" + i.toString(),
                  tooltip: "Démarrer",
                  backgroundColor: StrongrColors.blue,
                  child: Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                  ),
                  onPressed: () {},
                ),
              ),
            )
          ],
        ),
        onPressed: () {},
      ),
    );
  }

  @override
  void initState() {
    isEditMode = false;
    switch (DateTime.now().weekday) {
      case DateTime.monday:
        weekday = "Lundi";
        break;
      case DateTime.tuesday:
        weekday = "Mardi";
        break;
      case DateTime.wednesday:
        weekday = "Mercredi";
        break;
      case DateTime.thursday:
        weekday = "Jeudi";
        break;
      case DateTime.friday:
        weekday = "Vendredi";
        break;
      case DateTime.saturday:
        weekday = "Samedi";
        break;
      case DateTime.sunday:
        weekday = "Dimanche";
        break;
    }
    super.initState();
  }

  String getShortWeekDay(int day) {
    switch (day) {
      case DateTime.monday:
        return "Lun.";
        break;
      case DateTime.tuesday:
        return "Mar.";
        break;
      case DateTime.wednesday:
        return "Mer.";
        break;
      case DateTime.thursday:
        return "Jeu.";
        break;
      case DateTime.friday:
        return "Ven.";
        break;
      case DateTime.saturday:
        return "Sam.";
        break;
      case DateTime.sunday:
        return "Dim.";
        break;
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.name),
        leading: isEditMode
            ? IconButton(
                icon: Icon(Icons.close),
                onPressed: () => setState(() => isEditMode = false),
              )
            : BackButton(),
        actions: <Widget>[
          isEditMode
              ? IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {},
                )
              : IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => setState(() => isEditMode = true),
                ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            InkWell(
              onTap: isEditMode ? null : () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 100,
                  ),
                  Container(
                    padding: EdgeInsets.all(20),
                    child: StrongrText(
                      "Prise de masse",
                      // size: 22,
                      bold: true,
                    ),
                  ),
                  Opacity(
                    opacity: isEditMode ? 0 : 1,
                    child: Container(
                      height: 50,
                      width: 100,
                      child: Icon(Icons.info_outline),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: ScreenSize.width(context),
              height: 1,
              color: Colors.grey[350],
            ),
            Container(
              // margin: EdgeInsets.only(top: 10),
              height: ScreenSize.height(context) / 1.6,
              child:
                  // isEditMode
                  //     ? ReorderableListView(
                  //         onReorder: (oldIndex, newIndex) {},
                  //         children: <Widget>[
                  //           for (int i = 1; i <= 7; i++) buildListViewItem(i),
                  //         ],
                  //       )
                  // :
                  ListView(
                children: <Widget>[
                  for (int i = 1; i <= 7; i++)
                    i % 3 != 0
                        ? buildListViewItem(i)
                        : Container(
                            margin: i == 1 ? EdgeInsets.only(top: 5) : null,
                            key: ValueKey(i),
                            padding: EdgeInsets.all(5),
                            height: 90,
                            child: Container(
                              width: ScreenSize.width(context) / 1.2,
                              height: 60,
                              margin: EdgeInsets.only(left: 5, right: 5),
                              decoration: BoxDecoration(
                                color: StrongrColors.greyE,
                                border: Border.all(color: StrongrColors.greyD),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25.0),
                                ),
                              ),
                              child: FlatButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                                onPressed: isEditMode ? () {} : null,
                                child: Stack(
                                  children: <Widget>[
                                    Center(
                                      child: StrongrText(
                                        getShortWeekDay(i),
                                        size: 36,
                                        color: StrongrColors.greyC,
                                      ),
                                    ),
                                    Container(
                                      // color: Colors.red,
                                      width: ScreenSize.width(context),
                                      alignment: Alignment.centerRight,
                                      child: Visibility(
                                        visible: isEditMode,
                                        child: Container(
                                          width: 35,
                                          child: Icon(
                                            Icons.add,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                ],
              ),
            ),
            Container(
              width: ScreenSize.width(context),
              height: 1,
              color: Colors.grey[350],
            ),
            Visibility(
              visible: !isEditMode,
              child: Container(
                padding: EdgeInsets.all(10),
                width: ScreenSize.width(context),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    StrongrText(
                      "Créé le 01/01/2020 à 00:00.",
                      color: Colors.grey,
                      size: 16,
                    ),
                    StrongrText(
                      "Mis à jour le 01/01/2020 à 00:00.",
                      color: Colors.grey,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ),
            // Visibility(
            //   visible: isEditMode,
            //   child: Container(
            //     padding: EdgeInsets.all(10),
            //     width: ScreenSize.width(context),
            //     child: Center(
            //       child: FloatingActionButton(
            //         mini: true,
            //         backgroundColor: Colors.grey,
            //         onPressed: () {},
            //         child: Icon(Icons.add, color: Colors.white),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'program_fab_' + widget.id.toString(),
        backgroundColor: isEditMode
            ? Colors.red[800]
            : DateTime.now().weekday % 3 != 0
                ? StrongrColors.blue
                : Colors.grey,
        icon: Icon(
          isEditMode ? Icons.delete_outline : Icons.play_arrow,
          color: Colors.white,
        ),
        onPressed: isEditMode ? () {} : DateTime.now().weekday % 3 != 0 ? () {} : null,
        label: StrongrText(
          isEditMode ? "Supprimer" : "Démarrer (" + weekday + ")",
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
