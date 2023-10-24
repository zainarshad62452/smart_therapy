import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'dart:math';

import 'package:smart_therapy/main.dart';

class RenderData extends StatefulWidget {
  final List<dynamic> data;
  final int previewH;
  final int previewW;
  final double screenH;
  final double screenW;
  final String side;

  RenderData(
      {required this.side,required this.data,required this.previewH,required this.previewW,required this.screenH,required this.screenW});
  @override
  _RenderDataState createState() => _RenderDataState();
}

class _RenderDataState extends State<RenderData> {
  Map<String, List<double>>? inputArr;

  String excercise = 'squat';
  double upperRange = 300;
  double lowerRange = 500;
  bool? midCount, isCorrectPosture;
  int? _counter;
  Color? correctColor;
  double? shoulderLY;
  double? shoulderRY;
  double? kneeRY;
  double? kneeLY;
  double angle = 0;
  bool? squatUp;
  String whatToDo = 'Finding Posture';

  var leftEyePos = Vector(0, 0);
  var rightEyePos = Vector(0, 0);
  var leftShoulderPos = Vector(0, 0);
  var rightShoulderPos = Vector(0, 0);
  var leftHipPos = Vector(0, 0);
  var rightHipPos = Vector(0, 0);
  var leftElbowPos = Vector(0, 0);
  var rightElbowPos = Vector(0, 0);
  var leftWristPos = Vector(0, 0);
  var rightWristPos = Vector(0, 0);
  var leftKneePos = Vector(0, 0);
  var rightKneePos = Vector(0, 0);
  var leftAnklePos = Vector(0, 0);
  var rightAnklePos = Vector(0, 0);

 
 
  @override
  void initState() {
    inputArr = new Map();
    midCount = false;
    isCorrectPosture = false;
    _counter = 0;
    correctColor = Colors.red;
    shoulderLY = 0;
    shoulderRY = 0;
    kneeRY = 0;
    kneeLY = 0;
    squatUp = true;
    super.initState();
  }

  bool? _postureAccordingToExercise(Map<String, List<double>> poses) {
    setState(() {
      print('Left Shoulder');
      print(shoulderLY);
      shoulderLY = poses['leftShoulder']![1];
      shoulderRY = poses['rightShoulder']![1];
      kneeLY = poses['leftKnee']![1];
      kneeRY = poses['rightKnee']![1];
     angle =  widget.side == "left"?calculateAngle(leftElbowPos.x,leftElbowPos.y,leftShoulderPos.x,leftShoulderPos.y,leftKneePos.x,leftKneePos.y):widget.side=="right"?calculateAngle(rightElbowPos.x,rightElbowPos.y,rightShoulderPos.x,rightShoulderPos.y,rightKneePos.x,rightKneePos.y):0.0;
    });
    if (excercise == 'squat') {
      if (squatUp!) {
        return poses['leftShoulder']![1] < 320 &&
            poses['leftShoulder']![1] > 280 &&
            poses['rightShoulder']![1] < 320 &&
            poses['rightShoulder']![1] > 280 &&
            poses['rightKnee']![1] > 570 &&
            poses['leftKnee']![1] > 570;
         
      } else {
        return poses['leftShoulder']![1] > 475 &&
            poses['rightShoulder']![1] > 475;
      }
    }
    return null;
  }

  _checkCorrectPosture(Map<String, List<double>> poses) {
    if (_postureAccordingToExercise(poses)!) {
      if (!isCorrectPosture!) {
        setState(() {
          isCorrectPosture = true;
          correctColor = Colors.green;
        });
      }
    } else {
      if (isCorrectPosture!) {
        setState(() {
          isCorrectPosture = false;
          correctColor = Colors.red;
        });
      }
    }
  }

  Future<void> _countingLogic(Map<String, List<double>> poses) async {
    if (poses != null) {
      _checkCorrectPosture(poses);

      if (isCorrectPosture! && squatUp! && midCount == false) {
        //in correct initial posture
        setState(() {
          whatToDo = 'Squat Down';
          //correctColor = Colors.green;
        });
        squatUp = !squatUp!;
        isCorrectPosture = false;
      }

      //lowered all the way
      if (isCorrectPosture! && squatUp! && midCount == false) {
        midCount = true;
        isCorrectPosture = false;
        squatUp = squatUp!;
        setState(() {
          whatToDo = 'Go Up';
          //correctColor = Colors.green;
        });
      }

      //back up
      if (midCount! &&
          poses['leftShoulder']![1] < 320 &&
          poses['leftShoulder']![1] > 280 &&
          poses['rightShoulder']![1] < 320 &&
          poses['rightShoulder']![1] > 280) {
        incrementCounter();
        midCount = false;
        squatUp = squatUp!;
        setState(() {
          whatToDo = 'Go Up';
        });
      }
    }
  }

  void incrementCounter() {
    setState(() {
      _counter=_counter! + 1;
    });
  }
  double calculateAngle(double x1, double y1, double x2, double y2, double x3, double y3) {
    // Calculate vectors
    double vector1X = x2 - x1;
    double vector1Y = y2 - y1;
    double vector2X = x3 - x2;
    double vector2Y = y3 - y2;

    // Calculate dot product
    double dotProduct = vector1X * vector2X + vector1Y * vector2Y;

    // Calculate magnitudes
    double magnitude1 = sqrt(vector1X * vector1X + vector1Y * vector1Y);
    double magnitude2 = sqrt(vector2X * vector2X + vector2Y * vector2Y);

    // Calculate angle in radians
    double angleRadians = acos(dotProduct / (magnitude1 * magnitude2));

    // Convert angle to degrees and round to the nearest whole number
    double angleDegrees = (angleRadians * (180 / pi)).roundToDouble();

    return angleDegrees;
  }


  @override
  Widget build(BuildContext context) {
    void _getKeyPoints(k, x, y) {
      if (k["part"] == 'leftEye') {
        leftEyePos.x = x - 230;
        leftEyePos.y = y - 45;
      }
      if (k["part"] == 'rightEye') {
        rightEyePos.x = x - 230;
        rightEyePos.y = y - 45;
      }
      if (k["part"] == 'leftShoulder') {
        leftShoulderPos.x = x - 230;
        leftShoulderPos.y = y - 45;
      }
      if (k["part"] == 'rightShoulder') {
        rightShoulderPos.x = x - 230;
        rightShoulderPos.y = y - 45;
      }
      if (k["part"] == 'leftElbow') {
        leftElbowPos.x = x - 230;
        leftElbowPos.y = y - 45;
      }
      if (k["part"] == 'rightElbow') {
        rightElbowPos.x = x - 230;
        rightElbowPos.y = y - 45;
      }
      if (k["part"] == 'leftWrist') {
        leftWristPos.x = x - 230;
        leftWristPos.y = y - 45;
      }
      if (k["part"] == 'rightWrist') {
        rightWristPos.x = x - 230;
        rightWristPos.y = y - 45;
      }
      if (k["part"] == 'leftHip') {
        leftHipPos.x = x - 230;
        leftHipPos.y = y - 45;
      }
      if (k["part"] == 'rightHip') {
        rightHipPos.x = x - 230;
        rightHipPos.y = y - 45;
      }
      if (k["part"] == 'leftKnee') {
        leftKneePos.x = x - 230;
        leftKneePos.y = y - 45;
      }
      if (k["part"] == 'rightKnee') {
        rightKneePos.x = x - 230;
        rightKneePos.y = y - 45;
      }
      if (k["part"] == 'leftAnkle') {
        leftAnklePos.x = x - 230;
        leftAnklePos.y = y - 45;
      }
      if (k["part"] == 'rightAnkle') {
        rightAnklePos.x = x - 230;
        rightAnklePos.y = y - 45;
      }
    }

    List<Widget> _renderKeypoints() {
      var lists = <Widget>[];
      widget.data.forEach((re) {
        var list = re["keypoints"].values.map<Widget>((k) {
          var _x = k["x"];
          var _y = k["y"];
          var scaleW, scaleH, x, y;

          if (widget.screenH / widget.screenW >
              widget.previewH / widget.previewW) {
            scaleW = widget.screenH / widget.previewH * widget.previewW;
            scaleH = widget.screenH;
            var difW = (scaleW - widget.screenW) / scaleW;
            x = (_x - difW / 2) * scaleW;
            y = _y * scaleH;
          } else {
            scaleH = widget.screenW / widget.previewW * widget.previewH;
            scaleW = widget.screenW;
            var difH = (scaleH - widget.screenH) / scaleH;
            x = _x * scaleW;
            y = (_y - difH / 2) * scaleH;
          }
          inputArr![k['part']] = [x, y];
          //Mirroring
          if (x > 320) {
            var temp = x - 320;
            x = 320 - temp;
          } else {
            var temp = 320 - x;
            x = 320 + temp;
          }

          _getKeyPoints(k, x, y);

          if (k["part"] == 'leftEye') {
            leftEyePos.x = x - 230;
            leftEyePos.y = y - 45;
          }
          if (k["part"] == 'rightEye') {
            rightEyePos.x = x - 230;
            rightEyePos.y = y - 45;
          }
          return Positioned(
            left: x - 230,
            top: y - 50,
            width: 100,
            height: 15,
            child: Container(
                // child: Text(
                //   "● ${k["part"]}",
                //   style: TextStyle(
                //     color: Color.fromRGBO(37, 213, 253, 1.0),
                //     fontSize: 12.0,
                //   ),
                // ),
                ),
          );
        }).toList();

        _countingLogic(inputArr!);
        inputArr!.clear();

        lists..addAll(list);
      });
      //lists.clear();

      return lists;
    }

    return Stack(
      children: <Widget>[
        Stack(
          children: [

            widget.side == "all"?CustomPaint(
              painter:
                  MyPainter(left: leftShoulderPos, right: rightShoulderPos),
            ):const SizedBox(),
            widget.side =="left"?CustomPaint(
              painter: MyPainter(left: leftElbowPos, right: leftShoulderPos),
            ):widget.side == "all"?CustomPaint(
              painter: MyPainter(left: leftElbowPos, right: leftShoulderPos),
            ):SizedBox(),
            widget.side =="left"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: leftWristPos, right: leftElbowPos),
            ):SizedBox(),
            widget.side =="right"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: rightElbowPos, right: rightShoulderPos),
            ):SizedBox(),
            widget.side =="right"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: rightWristPos, right: rightElbowPos),
            ):SizedBox(),
            widget.side =="left"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: leftShoulderPos, right: leftHipPos),
            ):SizedBox(),
            widget.side =="left"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: leftHipPos, right: leftKneePos),
            ):SizedBox(),
            widget.side =="left"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: leftKneePos, right: leftAnklePos),
            ):SizedBox(),
            widget.side =="right"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: rightShoulderPos, right: rightHipPos),
            ):SizedBox(),
            widget.side =="right"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: rightHipPos, right: rightKneePos),
            ):SizedBox(),
            widget.side =="right"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: rightKneePos, right: rightAnklePos),
            ):SizedBox(),
            widget.side =="all"||widget.side == "all"?CustomPaint(
              painter: MyPainter(left: leftHipPos, right: rightHipPos),
            ):SizedBox(),
          ],
        ),
        Stack(children: _renderKeypoints()),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height:120,
            width: widget.screenW,
            decoration: BoxDecoration(
              color: correctColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                widget.side == 'all'?Text(
                  '$whatToDo\nSquats: ${_counter.toString()}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ):SizedBox(),
                Text(
                  'Angle ${angle.toInt()}°',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        // Align(
        //   alignment: Alignment.topCenter,
        //   child: TimerWidget(),
        // ),
      ],
    );
  }
}

class Vector {
  double x, y;
  Vector(this.x, this.y);
}

class MyPainter extends CustomPainter {
  Vector left;
  Vector right;
  MyPainter({required this.left,required this.right});
  @override
  void paint(Canvas canvas, Size size) {
    final p1 = Offset(left.x, left.y);
    final p2 = Offset(right.x, right.y);
    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 4;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
class TimerWidget extends StatefulWidget {
  @override
  _TimerWidgetState createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  Timer? _timer;
  int _seconds = 0;

  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  void stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
    }
  }

  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int remainingSeconds = seconds % 3600;
    int minutes = remainingSeconds ~/ 60;
    int remainingMinutes = remainingSeconds % 60;

    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingMinutes.toString().padLeft(2, '0');

    return '$hoursStr:$minutesStr:$secondsStr';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(
          formatTime(_seconds),
          style: TextStyle(fontSize: 24.0),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MaterialButton(
              color: kMainColor,
              onPressed: startTimer,
              child: Text('Start'),
            ),
            SizedBox(width: 20.0),
            MaterialButton(
              color: kMainColor,
              onPressed: stopTimer,
              child: Text('Stop'),
            ),
            SizedBox(width: 20.0),
            MaterialButton(
              color: kMainColor,
              onPressed: ()=>setState(() {
                stopTimer();
                _seconds = 0;
              }),
              child: Text('Clear'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

// class MyPainter extends CustomPainter {
//   Vector leftShoulderPos;
//   Vector rightShoulderPos;
//   Vector leftHipPos;
//   Vector rightHipPos;
//   Vector leftElbowPos;
//   Vector rightElbowPos;
//   Vector leftWristPos;
//   Vector rightWristPos;
//   Vector leftKneePos;
//   Vector rightKneePos;
//   Vector leftAnklePos;
//   Vector rightAnklePos;
  // MyPainter(
  //     {this.leftShoulderPos,
  //     this.leftAnklePos,
  //     this.leftElbowPos,
  //     this.leftHipPos,
  //     this.leftKneePos,
  //     this.leftWristPos,
  //     this.rightAnklePos,
  //     this.rightElbowPos,
  //     this.rightHipPos,
  //     this.rightKneePos,
  //     this.rightShoulderPos,
  //     this.rightWristPos});
//   @override
//   void paint(Canvas canvas, Size size) {
//     final pointMode = ui.PointMode.polygon;
//     final points = [
//       Offset(leftWristPos.x, leftWristPos.y),
//       Offset(leftElbowPos.x, leftElbowPos.y),
//       Offset(leftShoulderPos.x, leftShoulderPos.y),
//       Offset(leftHipPos.x, leftHipPos.y),
//       Offset(leftKneePos.x, leftKneePos.y),
//       Offset(leftAnklePos.x, leftAnklePos.y),
//       Offset(rightHipPos.x, rightHipPos.y),
//       Offset(rightKneePos.x, rightKneePos.y),
//       Offset(rightAnklePos.x, rightAnklePos.y),
//       Offset(rightShoulderPos.x, rightShoulderPos.y),
//       Offset(rightElbowPos.x, rightElbowPos.y),
//       Offset(rightWristPos.x, rightWristPos.y),
//     ];
//     final paint = Paint()
//       ..color = Colors.black
//       ..strokeWidth = 4
//       ..strokeCap = StrokeCap.round;
//     canvas.drawPoints(pointMode, points, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter old) {
//     return false;
//   }
// }

// CustomPaint(
//               painter: MyPainter(
//                   leftShoulderPos: leftShoulderPos,
//                   leftElbowPos: leftElbowPos,
//                   leftWristPos: leftWristPos,
//                   leftHipPos: leftHipPos,
//                   leftKneePos: leftKneePos,
//                   leftAnklePos: leftAnklePos,
//                   rightHipPos: rightHipPos,
//                   rightKneePos: rightKneePos,
//                   rightAnklePos: rightAnklePos,
//                   rightShoulderPos: rightShoulderPos,
//                   rightElbowPos: rightElbowPos,
//                   rightWristPos: rightWristPos),
//             ),
