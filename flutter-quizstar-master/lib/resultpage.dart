import 'package:flutter/material.dart';
import 'package:quizstar/home.dart';

class resultpage extends StatefulWidget {
  int marks;
  resultpage({Key key, @required this.marks}) : super(key: key);
  @override
  _resultpageState createState() => _resultpageState(marks);
}

class _resultpageState extends State<resultpage> {
  List<String> images = [
    "images/success.png",
    "images/good.png",
    "images/bad.png",
  ];

  String message;
  String image;

  @override
  void initState() {
    if (marks < 40) {
      image = images[2];
      message =
          "You Should Try Hard..\n" + "Điểm của bạn là $marks trên 100 điểm";
    } else if (marks < 70) {
      image = images[1];
      message =
          "You Can Do Better..\n" + "Điểm của bạn là $marks trên 100 điểm";
    } else {
      image = images[0];
      message =
          "You Did Very Well..\n" + "Điểm của bạn là $marks trên 100 điểm";
    }
    super.initState();
  }

  int marks;
  _resultpageState(this.marks);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Result",
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 8,
            child: Material(
              elevation: 10.0,
              child: Container(
                child: Column(
                  children: <Widget>[
                    Material(
                      child: Container(
                        width: 300.0,
                        height: 300.0,
                        child: ClipRect(
                          child: Image(
                            image: AssetImage(
                              image,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 15.0,
                        ),
                        child: Center(
                          child: Text(
                            message,
                            style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Quando",
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                OutlineButton(
                  onPressed: () {
                    Future.delayed(Duration(seconds: 8),
                            () =>
                                Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => homepage(),
                    )));


                   // Navigator.of(context).popUntil((route) => route.isFirst); // ko hoạt động


                    final snackBar = SnackBar(
                      content: const Text('Nếu kết quả chưa được tốt hãy cố gắng vào lần sau 🤗', style: TextStyle(fontSize: 13.5)),

                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      backgroundColor: Colors.blue,
                    ); ScaffoldMessenger.of(context)
                        .showSnackBar(snackBar);
                  },
                  // child: Text(
                  //   "Continue",
                  //   style: TextStyle(
                  //     fontSize: 18.0,
                  //   ),
                  // ),
                  child: Icon(Icons.home),
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 25.0,
                  ),
                  borderSide: BorderSide(width: 3.0, color: Colors.indigo),
                  splashColor: Colors.indigoAccent,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
