import 'package:flutter/material.dart';
import 'package:strongr/pages/others_pages/loading_page.dart';

const LightGrey = Color.fromRGBO(201, 201, 201, 1.0);
const LightLightGrey = Color.fromRGBO(222, 222, 222, 1.0);
const VeryLightGrey = Color.fromRGBO(245, 245, 245, 1.0);
const PrimaryColor = Color.fromRGBO(40, 140, 100, 1.0);
const SecondaryColor = Color.fromRGBO(20, 120, 80, 1.0);
const DarkColor = Color.fromRGBO(0, 100, 60, 1.0);
const List<String> ExercisesList = [
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

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        primaryColor: PrimaryColor,
        accentColor: SecondaryColor,
      ),
    home: new LoadingPage(),
    //home: new Homepage(),
  ));
}