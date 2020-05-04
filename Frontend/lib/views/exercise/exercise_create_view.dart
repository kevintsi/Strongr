import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:strongr/utils/screen_size.dart';
import 'package:strongr/utils/strongr_colors.dart';

class ExerciseCreateView extends StatefulWidget {
  final int id;
  final String name;

  ExerciseCreateView({
    @required this.id,
    @required this.name,
  });

  _ExerciseCreateViewState createState() => _ExerciseCreateViewState();
}

class _ExerciseCreateViewState extends State<ExerciseCreateView> {
  GlobalKey<FormState> _key = GlobalKey();
  bool _unique = false, _validate = false, _visibility = false, _enabled;
  TextEditingController _seriesCountController;
  int seriesCount, linesCount = 1;
  String errorText = "";
  List<String> _equipmentList = [
    "Équipement",
    "Aucun équipement",
    "Équipement 1",
    "Équipement 2",
    "Équipement 3",
    "Équipement 4",
    "Équipement 5",
  ];
  List<String> _workMethodsList = [
    "Méthode de travail",
    "Méthode de travail 1",
    "Méthode de travail 2",
    "Méthode de travail 3",
    "Méthode de travail 4",
    "Méthode de travail 5",
    "Méthode de travail personnalisée",
  ];

  @override
  void initState() {
    super.initState();
    _seriesCountController = TextEditingController(text: "");
    _enabled = !(_seriesCountController.text == "" ||
        _seriesCountController.text.startsWith("0") ||
        int.parse(_seriesCountController.text) <= 1 ||
        int.parse(_seriesCountController.text) > 10);
  }

  @override
  void dispose() {
    super.dispose();
    _seriesCountController.dispose();
  }

  String validateSeriesCount(String value) {
    // if (value.length == 0)
    //   return "Vous devez renseigner un nombre de séries";
    // if (value.startsWith("0"))
    //   return "Format incorrect";
    // if (int.parse(value) < 1)
    //   return "Vous ne pouvez pas effectuer moins d'une série";
    // if (int.parse(value) > 10)
    //   return "Vous ne pouvez pas effectuer plus de 10 séries";

    if (value.length == 0 ||
        value.startsWith("0") ||
        int.parse(value) < 1 ||
        int.parse(value) > 10)
      return "";
    else
      return null;
  }

  void sendToServer() {
    if (_key.currentState.validate() && _seriesCountController.text != "") {
      _key.currentState.save();
      setState(() {
        seriesCount = int.parse(_seriesCountController.text);
      });
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  Widget _buildSeparator(Size screenSize) {
    return Container(
      width: screenSize.width,
      height: 0.2,
      color: Colors.grey,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: BackButton(),
        title: Text(widget.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Form(
            key: _key,
            autovalidate: _validate,
            child: Column(
              children: <Widget>[
                Container(
                  //color: Colors.blue,
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: ScreenSize.width(context),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: DropdownButtonFormField(
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Calibri',
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                            onChanged: (newValue) {},
                            items: <DropdownMenuItem>[
                              for (var item in _equipmentList)
                                DropdownMenuItem(
                                  child: Text(item),
                                ),
                            ],
                            hint: Text("Équipement"),
                          ),
                        ),
                      ),
                      Container(
                        // color: Colors.red,
                        width: ScreenSize.width(context),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: DropdownButtonFormField(
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: 'Calibri',
                                fontWeight: FontWeight.w400,
                                color: Colors.grey),
                            onChanged: (newValue) {},
                            items: <DropdownMenuItem>[
                              for (var item in _workMethodsList)
                                DropdownMenuItem(
                                  child: Text(item),
                                ),
                            ],
                            hint: Text("Méthode de travail"),
                          ),
                        ),
                      ),
                      Container(
                        // color: Colors.blue,
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Flexible(
                                  child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 20, 5, 20),
                                      child: Container(
                                        // color: Colors.red,
                                        height: ScreenSize.height(context) / 8,
                                        child: TextFormField(
                                            maxLength: 2,
                                            validator: validateSeriesCount,
                                            onSaved: (String value) {
                                              seriesCount = int.parse(value);
                                            },
                                            keyboardType: TextInputType.number,
                                            inputFormatters: <
                                                TextInputFormatter>[
                                              WhitelistingTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            cursorColor: Colors.grey,
                                            controller: _seriesCountController,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              labelText: 'Séries',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              counterText: "",
                                            ),
                                            onChanged: (newValue) {
                                              if (_seriesCountController.text ==
                                                      "" ||
                                                  _seriesCountController.text
                                                      .startsWith("0") ||
                                                  int.parse(
                                                          _seriesCountController
                                                              .text) <
                                                      1 ||
                                                  int.parse(
                                                          _seriesCountController
                                                              .text) >
                                                      10) {
                                                setState(() {
                                                  _visibility = false;
                                                  linesCount = 0;
                                                  // print(linesCount);
                                                });
                                              } else {
                                                setState(() {
                                                  _visibility = true;
                                                });
                                                if (_unique) {
                                                  linesCount =
                                                      int.parse(newValue);
                                                  // print(linesCount);
                                                } else {
                                                  linesCount = 1;
                                                  // print(linesCount);
                                                }
                                              }
                                            }),
                                      )),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
                                  child: Text(
                                    "Rendre chaque série unique",
                                    style: TextStyle(
                                        color: _enabled ? Colors.grey : StrongrColors.greyC,
                                        fontSize: 16,
                                        fontFamily: 'Calibri',
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                  child: Switch(
                                      value: _unique,
                                      onChanged:
                                          !(_seriesCountController.text == "" ||
                                                  _seriesCountController.text
                                                      .startsWith("0") ||
                                                  int.parse(
                                                          _seriesCountController
                                                              .text) <=
                                                      1 ||
                                                  int.parse(
                                                          _seriesCountController
                                                              .text) >
                                                      10)
                                              ? (newValue) {
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  setState(() {
                                                    _unique = !_unique;
                                                  });
                                                  if (_unique == false) {
                                                    linesCount = 1;
                                                    // print(linesCount);
                                                  } else if (_seriesCountController
                                                              .text ==
                                                          "" ||
                                                      _seriesCountController
                                                          .text
                                                          .startsWith("0") ||
                                                      int.parse(
                                                              _seriesCountController
                                                                  .text) <
                                                          1 ||
                                                      int.parse(
                                                              _seriesCountController
                                                                  .text) >
                                                          10) {
                                                    linesCount = 0;
                                                    // print(linesCount);
                                                  } else {
                                                    linesCount = int.parse(
                                                        _seriesCountController
                                                            .text);
                                                    // print(linesCount);
                                                  }
                                                }
                                              : null),
                                ),
                              ],
                            ),
                            // Padding(
                            //   padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                            //   child: Text(_validate ? errorText : ""),
                            // ),
                          ],
                        ),
                      ),
                      // Padding(
                      //   padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      //   child: Text(_validate ? errorText : ""),
                      // ),
                    ],
                  ),
                ),
                Visibility(
                  visible: _visibility,
                  child: _buildSeparator(ScreenSize.size(context)),
                ),
                Expanded(
                  child: Visibility(
                    visible: _visibility,
                    child: Container(
                      //color: Colors.cyan,
                      child: ListView(
                        children: <Widget>[
                          for (int i = 0; i < linesCount; i++)
                            Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 20),
                                  child: Text(
                                    _unique ? (i + 1).toString() : "-",
                                    style: TextStyle(
                                        color:  StrongrColors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Flexible(
                                  child: Row(
                                    children: <Widget>[
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 10, 5, 10),
                                          child: TextFormField(
                                            maxLength: 3,
                                            keyboardType: TextInputType.number,
                                            cursorColor: Colors.grey,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              labelText: 'Répétitions',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              counterText: "",
                                            ),
                                          ),
                                        ),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5, 10, 5, 10),
                                          child: TextFormField(
                                            maxLength: 5,
                                            keyboardType:
                                                TextInputType.datetime,
                                            cursorColor: Colors.grey,
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  EdgeInsets.all(10),
                                              labelText: 'Repos',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              counterText: "",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.tune,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
