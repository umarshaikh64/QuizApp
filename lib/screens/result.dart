// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app/constants.dart';







class Result extends StatefulWidget {
  int totalScore;
  String name;
  int lengthOfQu;
  int quizLength;
   Result({ Key key,this.totalScore,this.name,this.lengthOfQu,this.quizLength}) : super(key: key);

  @override
  _ResultState createState() => _ResultState();
}

class _ResultState extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          SvgPicture.asset("assets/icons/bg.svg", fit: BoxFit.fill),
          Column(
            children: [
              Spacer(flex: 3),
              Text(
                "Score",
                style: Theme.of(context)
                    .textTheme
                    .headline3
                    .copyWith(color: kSecondaryColor),
              ),
              Spacer(),

              Container(
                width: 100,
                height: 100,
                child: Center(
                  child:widget.lengthOfQu >= widget.quizLength-widget.lengthOfQu ?Image.asset("assets/icons/trophy.png"):Text("Please Try Again thanks...!"),
                ),
              ),
              Spacer(),
              Container(),
              Text(
                "Student Name : ${widget.name} ${widget.lengthOfQu}",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: kSecondaryColor),
              ),
              Text(
                "Total Score : ${widget.totalScore}",
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: kSecondaryColor),
              ),
              Spacer(flex: 3),
            ],
          )
        ],
      ),
    );

  }
}