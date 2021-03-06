import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizstar/resultpage.dart';
import 'package:auto_size_text/auto_size_text.dart';
class getjson extends StatelessWidget {
  // accept the langname as a parameter

  String langname;
  getjson(this.langname);
  String assettoload;

  // a function
  // sets the asset to a particular JSON file
  // and opens the JSON
  setasset() {
    if (langname == "Toán học") {
      assettoload = "assets/toanhoc.json";
    } else if (langname == "Vật lý") {
      assettoload = "assets/vatly.json";
    } else if (langname == "Hóa học") {
      assettoload = "assets/hoahoc.json";
    } else if (langname == "Tiếng Anh") {
      assettoload = "assets/tienganh.json";
    } else {
      assettoload = "assets/sinhhoc.json";
    }
  }

  @override
  Widget build(BuildContext context) {
    // this function is called before the build so that
    // the string assettoload is avialable to the DefaultAssetBuilder
    setasset();
    // and now we return the FutureBuilder to load and decode JSON
    return FutureBuilder(
      future:
          DefaultAssetBundle.of(context).loadString(assettoload, cache: false),
      builder: (context, snapshot) {
        List mydata = json.decode(snapshot.data.toString());
        if (mydata == null) {
          return Scaffold(
            body: Center(
              child: Text(
                "Loading",
              ),
            ),
          );
        } else {
          return quizpage(mydata: mydata);
        }
      },
    );
  }
}

class quizpage extends StatefulWidget {
  // var mydata;
  final List mydata;

  quizpage({Key key, @required this.mydata}) : super(key: key);
  @override
  _quizpageState createState() => _quizpageState(mydata);
}

class _quizpageState extends State<quizpage> {
  final List mydata;
  _quizpageState(this.mydata);

  Color colortoshow = Colors.indigoAccent;
  Color right = Colors.green;
  Color wrong = Colors.red;
  int marks = 0;
  int i = 0;
  bool disableAnswer = false;
  // extra varibale to iterate
  int j = 1;
  int timer = 30;
  String showtimer = "30";
  var random_array;

  Map<String, Color> btncolor = {
    "a": Colors.indigoAccent,
    "b": Colors.indigoAccent,
    "c": Colors.indigoAccent,
    "d": Colors.indigoAccent,
  };

  bool canceltimer = false;

  // code inserted for choosing questions randomly
  // to create the array elements randomly use the dart:math module
  // -----     CODE TO GENERATE ARRAY RANDOMLY

  genrandomarray(){
    var distinctIds = [];
    var rand = new Random();
      for (int i = 0; ;) {
      distinctIds.add(rand.nextInt(101)); //giới hạn số câu lấy random
        random_array = distinctIds.toSet().toList();
        if(random_array.length < 20){   // số câu hỏi muốn có
          continue;
        }else{
          break;
        }
      }
      print(random_array);
  }

  //   var random_array;
  //   var distinctIds = [];
  //   var rand = new Random();
  //     for (int i = 0; ;) {
  //     distinctIds.add(rand.nextInt(10));
  //       random_array = distinctIds.toSet().toList();
  //       if(random_array.length < 10){
  //         continue;
  //       }else{
  //         break;
  //       }
  //     }
  //   print(random_array);

  // ----- END OF CODE
  // var random_array = [1, 6, 7, 2, 4, 10, 8, 3, 9, 5];

  // overriding the initstate function to start timer as this screen is created
  @override
  void initState() {
    starttimer();
    genrandomarray();
    super.initState();
  }

  // overriding the setstate function to be called only if mounted
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void starttimer() async {
    const onesec = Duration(seconds: 1);
    Timer.periodic(onesec, (Timer t) {
      setState(() {
        if (timer < 1) {
          t.cancel();
          nextquestion();
        } else if (canceltimer == true) {
          t.cancel();
        } else {
          timer = timer - 1;
        }
        showtimer = timer.toString();
      });
    });
  }

  void nextquestion() {
    canceltimer = false;
    timer = 30;
    setState(() {
      if (j < 20) { // điều kiện để chọn số câu kết thúc ra điểm
        i = random_array[j];
        j++;
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => resultpage(marks: marks),
        ));
      }
      btncolor["a"] = Colors.indigoAccent;
      btncolor["b"] = Colors.indigoAccent;
      btncolor["c"] = Colors.indigoAccent;
      btncolor["d"] = Colors.indigoAccent;
      disableAnswer = false;
    });
    starttimer();
  }

  void checkanswer(String k) {
    
    // in the previous version this was
    // mydata[2]["1"] == mydata[1]["1"][k]
    // which i forgot to change
    // so nake sure that this is now corrected
    if (mydata[2][i.toString()] == mydata[1][i.toString()][k]) {
      // just a print sattement to check the correct working
      // debugPrint(mydata[2][i.toString()] + " is equal to " + mydata[1][i.toString()][k]);
      marks = marks + 5;
      // changing the color variable to be green
      colortoshow = right;
    } else {
      // just a print sattement to check the correct working
      // debugPrint(mydata[2]["1"] + " is equal to " + mydata[1]["1"][k]);
      colortoshow = wrong;
    }
    setState(() {
      // applying the changed color to the particular button that was selected
      btncolor[k] = colortoshow;
      canceltimer = true;
      disableAnswer = true;
    });
    // nextquestion();
    // changed timer duration to 1 second
    Timer(Duration(seconds: 2), nextquestion);
  }


  Widget choicebutton(String k) {      // widget ô đáp án
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 20.0,
      ),
      child: MaterialButton(
        onPressed: () => checkanswer(k),
        child: AutoSizeText(
          mydata[1][i.toString()][k],
          style: TextStyle(
            color: Colors.white,
            fontFamily: "roboto",
            fontSize: 16,
            // fontWeight: FontWeight.bold
          ),
          maxLines: 3,
        ),
        color: btncolor[k],
        splashColor: Colors.indigo[700],
        highlightColor: Colors.indigo[700],
        minWidth: 200.0,
        height: 45.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    // SystemChrome.setPreferredOrientations(
    //     [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]); // định hướng thiết bị hướng xuống và lên
    // 2 dòng bỏ cũng đc

    return WillPopScope(

      // pop up thông báo không cho back
      onWillPop: () {
        return showDialog(   //hiển thị hộp thoại
            context: context,
            builder: (context) => AlertDialog(   //AlertDialog : hộp thoại cảnh báo
                  title: Text(
                    "LƯU Ý:",
                  ),
                  content: Text("Không thể quay lại khi đã bắt đầu bài thi !!!\n😝😝😝", style: TextStyle(fontSize: 21),),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Ok',
                      ),
                    )
                  ],
                ));
      },



      child: Scaffold(
        body: Column(

          children: <Widget>[

//             Expanded(
//               flex: 1,
//               child: Container(
//                 color: Colors.deepPurpleAccent,
//                 alignment: Alignment.center,
//                 child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//
//                   children: <Widget>[
//                     new Align(
//                       alignment: Alignment.topCenter,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                         child: Text(
//                           showtimer,
//                           style: TextStyle(
//                             fontSize: 30.0,
//                             fontWeight: FontWeight.w700,
//                             fontFamily: 'Times New Roman',
//                           ),
//                         ),
//                       ),
//                     ),
//                     // new Align(
//                     //   alignment: Alignment.bottomLeft,
//                     //   child: Container(
//                     //     padding: const EdgeInsets.symmetric(horizontal: 10.0),
//                     //     child:  Image.network(
//                     //       'https://miro.medium.com/max/1000/1*65RydaEZ7uy5YPTg9cxV8Q.gif',
//                     //       width: 300,
//                     //       height: 400,
//                     //       // fit: BoxFit.contain,
//                     //     ),
//                     //   ),
//                     // ),
//
//                     // Text(
//                     //   showtimer,
//                     //   style: TextStyle(
//                     //     fontSize: 30.0,
//                     //     fontWeight: FontWeight.w700,
//                     //     fontFamily: 'Times New Roman',
//                     //   ),
//                     // ),
// ]
//                 ),
//               ),
//             ),
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.deepPurpleAccent,                alignment: Alignment.topCenter,
                child: Center(
                  child: Text(
                    showtimer,
                    style: TextStyle(
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Times New Roman',
                    ),
                  ),


                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(15.0),
                alignment: Alignment.center,
                color: Colors.yellowAccent[200],
                child: Text(
                  mydata[0][i.toString()],
                  style: TextStyle(
                    fontSize: 17,
                    fontFamily: "roboto",
                  ),
                  maxLines: 100,
                ),
              ),
            ),
        // Container(
        //   decoration: BoxDecoration(
        //     image: DecorationImage(
        //       image: NetworkImage(
        //           "https://i.pinimg.com/originals/5b/4c/d2/5b4cd292f6f382ab8d8a51b9fcaad5ed.jpg"),
        //       fit: BoxFit.fitWidth,
        //     ),
        //   ),
        //   child:
             Expanded(
                flex: 5,
                child: AbsorbPointer(

                  absorbing: disableAnswer,
                    child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        choicebutton('a'),
                        choicebutton('b'),
                        choicebutton('c'),
                        choicebutton('d'),
                        // Image.network(
                        //   'https://miro.medium.com/max/1000/1*65RydaEZ7uy5YPTg9cxV8Q.gif',
                        //   width: 80,
                        //   height: 80,
                        //   fit: BoxFit.contain,
                        // )
                        Image.asset('assets/2222.gif', width: 80,height: 80),

                      ],
                    ),
                  ),
                ),
             // )
      ),


            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     // color: Colors.deepPurpleAccent,                alignment: Alignment.topCenter,
            //     child: Center(
            //         // child: Text(
            //         //   showtimer,
            //         //   style: TextStyle(
            //         //     fontSize: 30.0,
            //         //     fontWeight: FontWeight.w700,
            //         //     fontFamily: 'Times New Roman',
            //         //   ),
            //         // ),
            //       child: Image.network(
            //         'https://miro.medium.com/max/1000/1*65RydaEZ7uy5YPTg9cxV8Q.gif',
            //         // width: 1000,
            //         // height: 1000,
            //         fit: BoxFit.contain,
            //       )
            //
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
