// ignore_for_file: deprecated_member_use, missing_return
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app/constants.dart';
import 'package:http/http.dart' as http;
import 'package:quiz_app/screens/category.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  String usernameerror = '';
  String emaileerror = '';
  String passwordeerror = '';
  bool errorMessage = false;
  bool progress = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<http.Response> login() async {
   
    if (email.text.isNotEmpty && password.text.isNotEmpty) {
       setState(() {
      progress = true;
    });
      var uri = Uri.parse('https://www.salmanrajz.com/api/token');
      var userData = {
        "email": email.text,
        "password": password.text,
        "device_name": "android",
        "password_confirmation": password.text,
      };

      var client = http.Client();
      try {
        var response = await client.post(uri, body: userData);
        var decodedResponse = jsonDecode(response.body);
        print(decodedResponse);
        if (decodedResponse['ResponseCode'] == '0') {
           setState(() {
      progress = true;
    });
          showInSnackBar(decodedResponse['ResponseData']['email'] != null &&
                  decodedResponse['ResponseCode'] == '0'
              ? decodedResponse['ResponseData']['email'][0]
              : decodedResponse['ResponseData']['error'] != null &&
                      decodedResponse['ResponseCode'] == '0'
                  ? decodedResponse['ResponseData']['error']['message']
                  : "");
        }else{
           setState(() {
      progress = false;
    });
    
    addLocalUser(decodedResponse);
          Navigator.push(context,MaterialPageRoute(builder: (context)=>
          Category(category: decodedResponse['ResponseData']['test_categories'],)));
          print(decodedResponse);
           
        }
      } finally {
        client.close();
      }
    } else {
      setState(() {
        errorMessage = true;
        emaileerror = 'Please Enter email !';
        passwordeerror = 'Please Enter Your password !';
      });
    }
  }


void addLocalUser(decodedResponse)async{
   SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('user', [decodedResponse['ResponseData']['user_details']['id'].toString(),decodedResponse['ResponseData']['user_details']['name']]);
}
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        backgroundColor: Colors.red,
        content: new Text(value, style: TextStyle(color: Colors.white))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: [
          SvgPicture.asset("assets/icons/bg.svg",
              fit: BoxFit.fill, width: MediaQuery.of(context).size.width),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(flex: 1), //2/6
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Login To IQ",
                      style: Theme.of(context).textTheme.headline4.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text("Enter your informations below"),
                  ),
                  Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text("Email",
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.aspectRatio + 20,
                        )),
                  ), // 1/6
                  TextField(
                    controller: email,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF1C2341),
                      hintText: "Enter Email @",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Text(errorMessage ? emaileerror : '',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize:
                              MediaQuery.of(context).size.aspectRatio + 14,
                        )),
                  ),
                  Container(
                    height: 2,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Text("Password",
                        style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.aspectRatio + 20,
                        )),
                  ), // 1/6
                  TextField(
                  obscureText: true,
                    controller: password,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xFF1C2341),
                      hintText: "Enter Password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Text(errorMessage ? passwordeerror : '',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize:
                              MediaQuery.of(context).size.aspectRatio + 14,
                        )),
                  ),
                  Container(
                    height: 2,
                  ),
                  Spacer(), // 1/6
                  InkWell(
                    onTap: login,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(kDefaultPadding * 0.75), // 15
                      decoration: BoxDecoration(
                        gradient: kPrimaryGradient,
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child:progress?CircularProgressIndicator(): Text(
                        "Login",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  Spacer(flex: 2), // it will take 2/6 spaces
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
