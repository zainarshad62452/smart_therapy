import 'dart:async';

import 'package:flutter/material.dart';

import 'package:model_viewer_plus/model_viewer_plus.dart';

import 'package:provider/provider.dart';
import 'package:smart_therapy/providers/exerciseServices.dart';
import 'package:text_to_speech/text_to_speech.dart';
import '../models/exercise_item.dart';
import '../providers/auth_provider.dart';
import '../providers/cloudstore_provider.dart';

import '../widgets/custom_card.dart';
import '../widgets/custom_text_button.dart';
import '../widgets/custom_divider.dart';
import '../widgets/custom_elevated_button.dart';

import '../screens/webview_screen.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final ExerciseItem passedExerciseItem;
  final bool isTTS;

  const ExerciseDetailsScreen({
    Key? key,
    required this.passedExerciseItem,
    required this.isTTS
  }) : super(key: key);

  @override
  State<ExerciseDetailsScreen> createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen> {
  bool isRunning = false;
  int seconds = 0;
  late Timer timer;


  Future<void> startTimer() async {
    setState(() {
      seconds = 0;
    });
    if(widget.isTTS) {
      String a = "";
      for(var items in widget.passedExerciseItem.exItemProcedure){
        a = "$a. $items";
      }
      tts.speak(a);
    }
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        seconds += 1;
        isRunning=true;
      });
    });
    bool isAvailableToday = await ExerciseServices().checkExerciseForToday();
    print(isAvailableToday);
    if(!isAvailableToday){
      await ExerciseServices().addExercise();
    }
  }

  Future<void> stopTimer() async {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
    double value = await ExerciseServices().getSpecificExerciseData(widget.passedExerciseItem.exItemId);
    print(value);
    value = value+ double.parse((seconds/60).toStringAsFixed(1));
    print(value);
        await ExerciseServices().update(widget.passedExerciseItem.exItemId, value, ExerciseServices().extractDateComponents(DateTime.now()));
  }
  TextToSpeech tts = TextToSpeech();

  @override
  void initState() {
    if(widget.isTTS) {
      String a = "${widget.passedExerciseItem.exItemDescription}. Tap on the following steps to get the details. Steps to perform.";
      for(var items in widget.passedExerciseItem.exItemProcedure){
        a = "$a. $items";
      }
      tts.speak(a);
    }
    super.initState();
  }
  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {


    String formattedTime = '${(seconds ~/ 3600).toString().padLeft(2, '0')}:${((seconds % 3600) ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
    // List<ExerciseItem> filteredExercises =
    //     Provider.of<ExerciseListProvider>(context).getFilteredExerciseList([widget.exerciseId]);
    // finalExercise = filteredExercises[0];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    CustomTextButton(
                      onPressed: () => {
                        Navigator.pop(context),
                      },
                      padding: const EdgeInsets.all(6.0),
                      icon: Icons.arrow_back,
                      borderRadius: 50,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      widget.passedExerciseItem.exItemTitle,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const CustomDivider(),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: (){
                        tts.speak(widget.passedExerciseItem.exItemDescription);
                      },
                      child: CustomCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Summary',
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                            const CustomDivider(),
                            Text(widget.passedExerciseItem.exItemDescription,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomCard(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Steps to Perform',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const CustomDivider(),
                          ...widget.passedExerciseItem.exItemProcedure
                              .asMap()
                              .entries
                              .map(
                                (eachStep) => GestureDetector(
                                  onTap: (){
                                    tts.speak('${eachStep.key + 1}) ${eachStep.value}');
                                  },
                                  child: CustomCard(
                                    color: const Color(0xff4d4d4d),
                                    padding: const EdgeInsets.all(8.0),
                                    margin: const EdgeInsets.only(bottom: 8.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${eachStep.key + 1}) ',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            eachStep.value,
                                            style: Theme.of(context).textTheme.bodyMedium,
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                          // for (var eachCause in Provider.of<ExerciseListProvider>(context, listen: false)
                          //     .globalExerciseList[widget.exerciseIndex]
                          //     .exItemProcedure)
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 500,
                      child: CustomCard(
                        child: ModelViewer(
                          // src: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
                          //src: 'assets/3Dmodels/final.glb', // Human with given skeleton
                          // src: 'assets/3D models/back_exercise.glb',
                          src: widget.passedExerciseItem.exItemModelPath,
                          alt: "Animated 3D model of exercise",
                          ar: true,
                          autoRotate: true,
                          cameraControls: true,
                          disablePan: false,
                          autoPlay: true,
                          innerModelViewerHtml: """
                        <button class="hotspot" slot="hotspot-hand" data-position="0 1.93 -0.5" data-normal="-5.73 0.05 0.69">
                          <div class="annotation">Back Area is affected</div>
                        </button>
                          """,
                          relatedCss: """
                            .hotspot{
                          display: block;
                          width: 20px;
                          height: 20px;
                          border-radius: 10px;
                          border: none;
                          background-color: blue;
                          box-sizing: border-box;
                          pointer-events: none;
                        }
                      
                        .hotspot[slot="hotspot-hand"]{
                          --min-hotspot-opacity: 0;
                          background-color: red;
                        }
                      
                        .hotspot[slot="hotspot-foot"]:not([data-visible]) {
                          background-color: transparent;
                          border: 3px solid blue;
                        }
                      
                        .annotation{
                          background-color: #fff;
                          position: absolute;
                          transform: translate(10px, 10px);
                          border-radius: 10px;
                          padding: 10px;
                        }
                        /* This keeps child nodes hidden while the element loads */
                        :not(:defined) > * {
                          display: none;
                        }
                          """,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Provider.of<AuthProvider>(context).currentUser != null
                        ? CustomElevatedButton(
                            onPressed: () => {
                              debugPrint(
                                'Add exercise to Firestore List of: ${Provider.of<AuthProvider>(context, listen: false).currentUser?.uid}',
                              ),
                              Provider.of<CloudstoreProvider>(context, listen: false).addToUserExListById(
                                context,
                                Provider.of<AuthProvider>(context, listen: false).currentUser?.uid,
                                widget.passedExerciseItem.exItemId,
                              ),
                              // Provider.of<CloudstoreProvider>(context, listen: false).setUserDataById(
                              //   Provider.of<AuthProvider>(context, listen: false).currentUser!.uid,
                              //   {
                              //     'exList': [
                              //       {
                              //         'exListItemId': Provider.of<ExerciseListProvider>(context, listen: false)
                              //             .globalExerciseList[widget.exerciseIndex]
                              //             .exItemId,
                              //         'exListItemTimestamp': Timestamp.now()
                              //       },
                              //     ],
                              //   },
                              // ),
                              //   Provider.of<CloudstoreProvider>(context, listen: false).setUserData(
                              //   passedId: _newUserId!,
                              //   passedName: _nameController.text.trim(),
                              //   passedEmail: _emailController.text.trim(),
                              //   passedAge: int.parse(_ageController.text.trim()),
                              // );
                            },
                            icon: Icons.add,
                            title: 'Add Treatment Plan',
                          )
                        : Container(),
                    const SizedBox(height: 20),
                    CustomElevatedButton(
                      onPressed: () => {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => WebviewScreen(
                              passedSearchQuery: widget.passedExerciseItem.exItemTitle,
                            ),
                          ),
                        )
                      },
                      child: Row(
                        children: [
                          const Icon(Icons.travel_explore),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Search the Web',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Visibility(
                      visible: isRunning,
                        child: Column(
                      children: [
                        SizedBox(height: 20),
                        Text(
                          formattedTime,
                          style: TextStyle(fontSize: 40),
                        ),
                      ],
                    )),
                    CustomElevatedButton(
                      onPressed: (){
                        !isRunning?startTimer():stopTimer();
                      },
                      child: Row(
                        children: [
                          Icon(!isRunning?Icons.play_arrow_rounded:Icons.pause),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            !isRunning?'Start Exercise':'Stop Exercise',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                // CustomCard(
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Text(
                //         'Procedure',
                //         style: TextStyle(
                //           color: Theme.of(context).primaryColor,
                //         ),
                //       ),
                //       for (var eachSymptom in Provider.of<ExerciseList>(context, listen: false)
                //           .globalExerciseList[widget.exerciseIndex]
                //           .exItemProcedure)
                //         Padding(
                //           padding: const EdgeInsets.all(4.0),
                //           child: Text('- $eachSymptom', style: Theme.of(context).textTheme.bodyMedium),
                //         )
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 20),
                // Expanded(
                //   child: ListView.builder(
                //     itemCount: Provider.of<DisorderList>(context, listen: false)
                //         .globalDisorderList[widget.disorderIndex]
                //         .disItemImagePaths
                //         .length,
                //     itemBuilder: (context, disorderImageIndex) => Container(
                //       height: 200,
                //       decoration: BoxDecoration(
                //         image: DecorationImage(
                //           image: AssetImage(
                //             Provider.of<DisorderList>(context, listen: false)
                //                 .globalDisorderList[widget.disorderIndex]
                //                 .disItemImagePaths[disorderImageIndex],
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
