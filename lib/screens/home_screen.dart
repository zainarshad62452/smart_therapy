import 'dart:async';

import 'package:get/get.dart';
import 'package:smart_therapy/ai/pushed_pageS.dart';
import 'package:smart_therapy/main.dart';
import 'package:smart_therapy/screens/doctorsScreen.dart';
import 'package:smart_therapy/screens/model_viewer_screen.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
// import '../ai/main.dart';
// import '../main.dart';
import '../providers/auth_provider.dart';

// import '../widgets/custom_drawer.dart';
import '../widgets/custom_elevated_button.dart';
import '../widgets/custom_card.dart';
import '../widgets/custom_text_button.dart';
import 'account_screen.dart';
import 'disorders_screen.dart';
import 'exercises_screen.dart';

// import 't-pose.dart';
// import 'model_viewer_screen.dart';
// import 'disorders_screen.dart';
// import 'exercises_screen.dart;

class HomeScreen extends StatefulWidget {
  const HomeScreen(cameras, {Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // GlobalKey<ScaffoldState> homeScreenScaffoldKey = GlobalKey<ScaffoldState>(); // for opening the drawer

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: homeScreenScaffoldKey, // for opening the drawer
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => {
      //     print(
      //       Provider.of<DisorderList>(context, listen: false).globalDisorderList[0],
      //       // context.watch<DisorderList>().globalDisorderList[0],
      //     ),
      //   },
      // ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => {
                            // widget.passedKey.currentState?.openDrawer(),
                            Scaffold.of(context).openDrawer(),
                          },
                          icon: const Icon(
                            Icons.menu,
                            size: 34,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          'Smart Therapy',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AccountScreen(),
                          ),
                        ),
                      },
                      icon: Icon(
                        Icons.account_circle,
                        color: Theme.of(context).primaryColor,
                        size: 34,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Provider.of<AuthProvider>(context).currentUser != null
                            ? 'Welcome to Smart Therapy,\n${Provider.of<AuthProvider>(context).currentUser!.displayName}!'
                            : 'Welcome to Smart Therapy!',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'The perfect personal companion app to support your physical therapy',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CustomCard(
                  child: Text(
                    'Solve all of your physiotherapy related problems',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                // SizedBox(
                //   height: 400,
                //   child: CustomCard(
                //     child: Stack(
                //       children: [
                //         ModelViewer(
                //           src: 'assets/3d_models/tpose.glb',
                //           autoRotate: false,
                //           cameraControls: true,
                //           disableZoom: true,
                //           disablePan: true,
                //           ar: false,
                //         ),
                //         Positioned(
                //           top: 0,
                //           left: 0,
                //           child: CustomTextButton(
                //             onPressed: () => {},
                //             childPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                //             title: 'Neck',
                //           ),
                //         ),
                //         Positioned(
                //           top: 0,
                //           right: 0,
                //           child: CustomTextButton(
                //             onPressed: () => {},
                //             childPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                //             title: 'Shoulder',
                //           ),
                //         ),
                //         Positioned(
                //           bottom: 0,
                //           left: 0,
                //           child: CustomTextButton(
                //             onPressed: () => {},
                //             childPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                //             title: 'Back',
                //           ),
                //         ),
                //         Positioned(
                //           bottom: 0,
                //           right: 0,
                //           child: CustomTextButton(
                //             onPressed: () => {},
                //             childPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                //             title: 'Hamstring',
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),
                // const SizedBox(height: 20),
                // CustomElevatedButton(
                //   onPressed: () => {
                //     Navigator.of(context).push(
                //       MaterialPageRoute(
                //         builder: (context) => const ModelViewerScreen(),
                //       ),
                //     )
                //   },
                //   icon: Icons.view_in_ar,
                //   title: 'Try 3D & AR Demo',
                // ),
                const SizedBox(height: 20),
                CustomCard(
                  child: Text(
                    'Browse from numerous disorders and exercises and get their detailed information',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const DisordersScreen(),
                      ),
                    )
                  },
                  backgroundImage: 'assets/images/disorders.jpeg',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                    child: Text(
                      'Browse Disorders',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  onPressed: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ExercisesScreen(),
                      ),
                    )
                  },
                  backgroundImage: 'assets/images/exercises.jpeg',
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                    child: Text(
                      'Browse Exercises',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                CustomElevatedButton(
                  onPressed: () async {
                    showDialog(context: context, builder: (ctx)=>AlertDialog(
                      actions: [
                        TextButton(onPressed: (){
                          Get.back();
                        }, child: Text("Cancel"))
                      ],
                      title: Text("Please select..."),content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                      MaterialButton(
                        onPressed: () async {
                        final encodedQuery = Uri.encodeQueryComponent("Physiotherapist near me");
                        final Uri url = Uri.parse("https://www.google.com/maps/search/?api=1&query=$encodedQuery");
                        if (!await launchUrl(url)) {
                        throw Exception('Could not launch $url');
                        }
                      },child: Text("Google Map"),
                      color: kMainColor,
                      ),
                      SizedBox(height: 30.0,),
                      MaterialButton(
                        color: kMainColor,
                        onPressed: (){
                        Get.to(()=>DoctorListScreen());
                      },child: Text("Doctors"),),
                    ],),));
                  },
                  child: Row(
                    children: [
                      const Icon(Icons.location_on),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Physiotherapists Near Me',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomElevatedButton(
                  // onPressed: () => onSelectS(context: context, modelName: 'posenet'),
                  onPressed: () async {
                    try {
                      List<CameraDescription>? new_cameras = await availableCameras();
                      showDialog(context: context, builder: (ctx)=>AlertDialog(title: Text('Please select a suitable body side!.'),content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MaterialButton(
                            color: kMainColor,onPressed: (){
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PushedPageS(
                                  cameras: new_cameras,
                                  title: 'posenet', side: 'left',
                                ),
                              ),
                            );

                          },child: Text("Left-Side",style: TextStyle(color: Colors.white),),),
                          SizedBox(height: 20.0,),
                          MaterialButton(
                            color: kMainColor,onPressed: (){
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PushedPageS(
                                  cameras: new_cameras,
                                  title: 'posenet', side: 'right',
                                ),
                              ),
                            );
                          },child: Text("Right-Side",style: TextStyle(color: Colors.white),),),
                          SizedBox(height: 20.0,),
                          MaterialButton(
                            color: kMainColor,
                            onPressed: (){
                              Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PushedPageS(
                                  cameras: new_cameras,
                                  title: 'posenet', side: 'all',
                                ),
                              ),
                            );
                          },child: Text("All Body",style: TextStyle(color: Colors.white),),),
                        ],
                      ),),);

                    } on CameraException catch (e) {
                      print('Error: $e.code\nError Message: $e.message');
                    }
                  },
                  // onPressed: () => {
                  //   Navigator.of(context).push(
                  //     MaterialPageRoute(
                  //       builder: (context) => PushedPageS(
                  //         cameras: cameras!,
                  //         title: 'posenet',
                  //       ),
                  //     ),
                  //   )
                  // },
                  icon: Icons.camera_alt,
                  title: 'Detect Your Pose',
                ),
                const SizedBox(height: 20.0),
                // Provider.of<AuthProvider>(context).currentUser != null
                //     ? CustomElevatedButton(
                //         onPressed: () => {},
                //         trailingIcon: Icons.arrow_forward,
                //         title: 'Continue Treatment',
                //       )
                //     : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void onSelectS({required BuildContext context, required String modelName}) async {

  // }
}
