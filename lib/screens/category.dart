// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:quiz_app/constants.dart';
import 'package:quiz_app/screens/quation.dart';

class Category extends StatefulWidget {
  List category;
  Category({Key key, this.category}) : super(key: key);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SvgPicture.asset("assets/icons/bg.svg",
              fit: BoxFit.fill, width: MediaQuery.of(context).size.width),
          Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //  Spacer(),
                  Container(
                    margin: EdgeInsets.symmetric(
                        vertical: MediaQuery.of(context).size.height / 6),
                   
                    child: Text(
                      "IQ Category",
                      style: TextStyle(
                          fontSize:
                              MediaQuery.of(context).size.aspectRatio * 78),
                    ),
                  ),
                  // Spacer(),
                  Container(
                    width: MediaQuery.of(context).size.width * 8,
                    height: MediaQuery.of(context).size.height / 2,
                    child: GridView.builder(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                        itemCount: widget.category.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            // mainAxisExtent: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 8),
                        itemBuilder: (context, i) {
                          return GestureDetector(
                            onTap: (() {
                              //  print(widget.category[i]['id'].toString());
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Quation(
                                            id: widget.category[i]['id']
                                                .toString(),
                                            categoryName: widget.category[i]
                                                ['category_name'],
                                          )));
                            }),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      width: 1, color: kSecondaryColor)),
                              height: 20,
                              //  color: Colors.red,
                              child: Text(
                                widget.category[i]['category_name'],
                                style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
