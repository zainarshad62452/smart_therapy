import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:smart_therapy/main.dart';

import 'bottom_nav_wrapper_screen.dart';

class SplashScreen extends StatelessWidget {
  List<CameraDescription>? cameras;
   SplashScreen({super.key,cameras});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 3),(){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>BottomNavWrapperScreen(cameras)), (route) => false);
        });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: double.infinity,),
          Column(
            children: [
              Text(
                "Smart Therapy",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const Icon(Icons.accessibility_sharp,color: Colors.white,size: 50.0,),
            ],
          ),
          const SizedBox(height: 40.0,),
          const CircularProgressIndicator(color: Colors.white,backgroundColor: kMainColor,),
        ],
      ),
    );
  }
}
