// ignore_for_file: missing_return, must_be_immutable, non_constant_identifier_names, unused_field
import 'dart:async';
import 'dart:convert';
// import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tex/flutter_tex.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/screens/result.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Quation extends StatefulWidget {
  final TeXViewRenderingEngine renderingEngine;
  String id;
  String categoryName;
  Quation(
      {Key key,
      this.id,
      this.renderingEngine = const TeXViewRenderingEngine.katex(),
      this.categoryName})
      : super(key: key);

  @override
  _QuationState createState() => _QuationState();
}

class _QuationState extends State<Quation> {
  // CountDownController _controller = CountDownController();
  int _duration = 30;
  List QuizData = [];
  String selectedOptionId;
  int currentQuizIndex = 0;
  int totalScore = 0;
  bool goNext = false;
  String isCorrect='';
  bool selected = false;

  String error = '';
  var userdata = [];
  Future<http.Response> getQuation() async {
    print(widget.id);

    SharedPreferences pres = await SharedPreferences.getInstance();
    for (var item in pres.getStringList('user')) {
      setState(() {
        userdata.add(item);
      });
    }
    print(userdata);
    var uri = Uri.parse('https://www.salmanrajz.com/api/start_exams');

    try {
      var response = await http.post(uri, body: {"category_id": widget.id});

      var decodeData = jsonDecode(response.body);
      print(response.body);
      print(widget.id);

      for (var item in decodeData['ResponseData']) {
        setState(() {
          QuizData.add(item);
        });
        print(item);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<http.Response> endExam() async {
    var uri = Uri.parse('https://www.salmanrajz.com/api/end_exams');
    var client = http.Client();
    try {
      var response = await client.post(uri, body: {
        "user_id": userdata[0].toString(),
        "correct": selectedOptionId != null ? selectedOptionId : '0',
        "total_score": totalScore.toString(),
        "category_id": widget.id
      });

      var decodeData = jsonDecode(response.body);
      print(decodeData);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Result(totalScore: totalScore, name: userdata[1],lengthOfQu: currentQuizIndex,quizLength: QuizData.length,)));
    } finally {
      client.close();
    }
  }

  @override
  void initState() {
    print("object");
    Timer(Duration(milliseconds: 500), (() {
      getQuation();
    }));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset("assets/icons/bg.svg",
              fit: BoxFit.fill, width: MediaQuery.of(context).size.width),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.1,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(
                                top: MediaQuery.of(context).size.height * 0.05),
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text("IQ Quiz",
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context)
                                            .size
                                            .aspectRatio +
                                        25))),
                        Spacer(),
                        //   Center(
                        //     child: Container(
                        //       margin: EdgeInsets.only(top:30),
                        //       padding: EdgeInsets.symmetric(vertical: 10),
                        //       width:MediaQuery.of(context).size.width*0.3,
                        //       height:MediaQuery.of(context).size.height*0.1,
                        //       // color: Colors.red,
                        //           child: Center(
                        //             child: CircularCountDownTimer(
                        //         duration: _duration,
                        //           textStyle: TextStyle(
                        //        fontSize: 12.0, color: Colors.white, fontWeight: FontWeight.bold),
                        //         initialDuration: 0,
                        //         fillColor: Color(0xFF46A0AE),
                        //         controller:_controller,
                        //         width: MediaQuery.of(context).size.width / 4,
                        //         height: MediaQuery.of(context).size.height / 4,
                        //         ringColor: Colors.grey[300],
                        //         autoStart: true,
                        //         strokeWidth: 3,
                        //         onStart: () {
                        //             print('Countdown Started');
                        //         },
                        //         onComplete: () {
                        //              setState(() {
                        //     if (currentQuizIndex != QuizData.length - 1){
                        //       currentQuizIndex++;
                        //       goNext=false;
                        //       _controller.restart(duration: _duration);

                        //     }else{
                        //   print("alll");
                        //   endExam();

                        //     }
                        // });
                        //             print('Countdown Ended');
                        //         },
                        //       ),
                        //           ),
                        //     ),
                        //   ),
                      ],
                    ),
                  ),
                  Divider(
                    color: Color(0xFF46A0AE),
                    thickness: 3,
                  ),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Text("${widget.categoryName} ",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.aspectRatio +
                                      35))),
                  // Container(height:MediaQuery.of(context).size.height*0.15),
                  Container(
                    width: MediaQuery.of(context).size.width * 9,
                    // height: 00,

                    child: QuizData.isNotEmpty
                        ? Container(
                            // width:200,
                            // height:00,
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child:TeXView(
                              renderingEngine: widget.renderingEngine,
                              child: TeXViewColumn(children: [
                                TeXViewDocument(
                                    QuizData[currentQuizIndex]['questions'],
                                    style: TeXViewStyle.fromCSS('''
                    padding:10px;
                     
                    ''')),
                                TeXViewGroup(
                                    children: [
                                      TeXViewGroupItem(
                                        id: '1',
                                        child: TeXViewDocument(
                                            '${QuizData[currentQuizIndex]['option'][0]}',
                                            style: TeXViewStyle.fromCSS('''
                        padding:14px;
                        ''')),
                                      ),
                                      TeXViewGroupItem(
                                        id: '2',
                                        child: TeXViewDocument(
                                            '${QuizData[currentQuizIndex]['option'][1]}',
                                            style: TeXViewStyle.fromCSS('''
                        padding:14px;
                        ''')),
                                      ),
                                      TeXViewGroupItem(
                                        id: '3',
                                        child: TeXViewDocument(
                                            '${QuizData[currentQuizIndex]['option'][2]}',
                                            style: TeXViewStyle.fromCSS('''
                        padding:14px;
                        ''')),
                                      ),
                                      TeXViewGroupItem(
                                        id: '4',
                                        child: TeXViewDocument(
                                            '${QuizData[currentQuizIndex]['option'][3]}',
                                            style: TeXViewStyle.fromCSS('''
                        padding:14px;
                        ''')),
                                      ),
                                    ],
                                    selectedItemStyle: TeXViewStyle(
                                        backgroundColor:
                                       
                                             Colors.green[100],
                                          
                                        borderRadius:
                                            TeXViewBorderRadius.all(10),
                                        border: TeXViewBorder.all(
                                            TeXViewBorderDecoration(
                                                borderWidth: 1,
                                                borderColor:
                                                  
                                             Colors.green[100],
                                          
                                           )),
                                        margin: TeXViewMargin.all(10)),
                                    normalItemStyle: TeXViewStyle(
                                      margin: TeXViewMargin.all(10),
                                      borderRadius: TeXViewBorderRadius.all(10),
                                      border: TeXViewBorder.all(
                                          TeXViewBorderDecoration(
                                              borderWidth: 1,
                                              borderColor: Colors.green[900])),
                                    ),
                                  
                                    onTap: (id) {
                                      print(id);

                                      selectedOptionId = id;
                                      setState(() {
                                        goNext = true;
                                        selected=true;
                                      });
                                      if (id ==
                                          QuizData[currentQuizIndex]['correct']
                                              .toString()) {
                                        print("correct Answer ${QuizData[currentQuizIndex]['correct'].toString()}");

                                        setState(() {
                                          error="The Correct Answer is  ${QuizData[currentQuizIndex]['correct'].toString()}";
                                          totalScore += 10;
                                        isCorrect ="isCorrect";
                                        });
                                      } else {
                                        setState(() {
                                          isCorrect ="Wrong";
                                          error="The Correct Answer is  ${QuizData[currentQuizIndex]['correct'].toString()}";

                                        });
                                        print('Wrong Answer');
                                      }
                                    })
                              ]),
                              style: TeXViewStyle(
                                padding: TeXViewPadding.all(20),
                                borderRadius: TeXViewBorderRadius.all(2),
                                border: TeXViewBorder.all(
                                  TeXViewBorderDecoration(
                                      borderColor: Colors.blue,
                                      borderStyle: TeXViewBorderStyle.Solid,
                                      borderWidth: 2),
                                ),
                                backgroundColor: Colors.white,
                              ),
                            ),
                          )
                        : Container(
                            child: Center(child: CircularProgressIndicator())),
                  ),
                  Container(height: MediaQuery.of(context).size.height * 0.1),
                  Container(
                    child:Center(
                      child: Text("$error ",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    )
                  ),

                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 130, vertical: 10),
                    child: InkWell(
                      onTap: goNext
                          ? () => {
                            print(isCorrect),
                                print(currentQuizIndex == QuizData.length - 1),
                                setState(() {
                                  if (currentQuizIndex != QuizData.length - 1) {
                                    currentQuizIndex++;
                                    goNext = false;
                                    isCorrect ="";
                                    selected=false;
                                    error='';
                                    // _controller.restart(duration: _duration);
                                  } else {
                                    print("alll");
                                    endExam();
                                  }
                                })
                              }
                          : () => {},
                      child: Container(
                        width: double.infinity,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                        decoration: BoxDecoration(
                          gradient: goNext
                              ? kPrimaryGradient
                              : LinearGradient(colors: [
                                  Colors.grey[400],
                                  Colors.grey[400],
                                ]),
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Text(
                          currentQuizIndex == QuizData.length - 1
                              ? "Submit"
                              : "Next",
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          selected?
                            Center(
                              child: Container(
                                transform: Matrix4.translationValues(0, -90, 0),
                                width: MediaQuery.of(context).size.width*0.9,
                                height: MediaQuery.of(context).size.height*0.4,
                                color: Colors.transparent,
                              ),
                            )
                            : Text("")
        ],
      ),
    );
  }
}
