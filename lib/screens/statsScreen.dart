import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dashed_circular_progress_bar/dashed_circular_progress_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_therapy/main.dart';

import '../models/exercise_model.dart';
import '../widgets/custom_text_button.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  var selectedCardIndex = 0.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
body: SafeArea(
  child: Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 10),
            Text(
              'My Stats',
              style: Theme.of(context).textTheme.displayLarge,
            ),
          ],
        ),
        const SizedBox(height: 20),
    StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection("stats")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Text('No exercise data available.');
        }

        // Convert Firestore data to Exercise model
        List<Exercise> exercises = snapshot.data!.docs.map((document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return Exercise.fromJson(data);
        }).toList();

        exercises.sort((a, b) => b.date.compareTo(a.date));


        return Obx(() => Column(
          children: [
            Container(
              height:60,
              width: double.infinity,

              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: GestureDetector(
                      onTap: () {

                        print(index);
                        if (selectedCardIndex == index) {
                          selectedCardIndex.value = -1; // Deselect the card
                        } else {
                          selectedCardIndex.value = index; // Select the card
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.0),
                          border: selectedCardIndex == index?Border.all(color: kMainColor,width: 5.0):Border.all(width: 0.0),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Text(exercises[index].uid,style: TextStyle(color: Colors.black),), // Display the date here
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            selectedCardIndex.value !=-1?statsWidget(exercise: exercises[selectedCardIndex.value],):Center(child: Text("No workout.Do some exercise."),),
          ],
        ));
      },
    ),
      ],
    ),
  ),
),
    );
  }
  String extractDateComponents(DateTime date) {
    int year = date.year;
    int month = date.month;
    int day = date.day;
    return '$year-$month-$day'; // Adjust the format as needed
  }
}

class statsWidget extends StatefulWidget {
  const statsWidget({
    super.key,
    required this.exercise,
  });

  final Exercise exercise;

  @override
  State<statsWidget> createState() => _statsWidgetState();
}

class _statsWidgetState extends State<statsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: statsCard(name: 'Forward Flexion', maxProgress: 60, progress: widget.exercise.forwardFlexion,)),
            Expanded(child: statsCard(name: 'Scapular Retractions', maxProgress: 60, progress: widget.exercise.scapularRetractions,)),
            // statsCard(valueNotifier: _valueNotifier, name: 'Exercise', maxProgress: 80, progress: 60,),
          ],
        ),
        Row(
          children: [
            Expanded(child: statsCard(name: 'Knees Stretch', maxProgress: 60, progress: widget.exercise.kneesStretch,)),
            Expanded(child: statsCard(name: 'Seated Leg Raises', maxProgress: 60, progress: widget.exercise.seatedLegRaises,)),
            // statsCard(valueNotifier: _valueNotifier, name: 'Exercise', maxProgress: 80, progress: 60,),
          ],
        ),
        Row(
          children: [
            Expanded(child: statsCard(name: 'Chin to Chest', maxProgress: 60, progress:widget.exercise.chinToChest,)),
            const Expanded(child: SizedBox())
            // statsCard(valueNotifier: _valueNotifier, name: 'Exercise', maxProgress: 80, progress: 60,),
          ],
        ),
      ],
    );
  }
}

class statsCard extends StatefulWidget {
   statsCard({
    super.key,
    required this.name,
    required this.maxProgress,
    required this.progress});
  String name;
  double maxProgress,progress;

  @override
  State<statsCard> createState() => _statsCardState();
}

class _statsCardState extends State<statsCard> {
  final ValueNotifier<double> _valueNotifier = ValueNotifier(0);
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.name,style: TextStyle(color: kMainColor),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DashedCircularProgressBar.aspectRatio(
              aspectRatio: 1.5, // width ÷ height
              valueNotifier: _valueNotifier,
              progress: widget.progress,
              maxProgress: widget.maxProgress,
              corners: StrokeCap.butt,
              foregroundColor: kMainColor,
              backgroundColor: const Color(0xffeeeeee),
              foregroundStrokeWidth: 7,
              backgroundStrokeWidth: 7,
              animation: true,
              child: Center(
                child: ValueListenableBuilder(
                  valueListenable: _valueNotifier,
                  builder: (_, double value, __) => Text(
                    '${value.toInt()} m',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        fontSize: 30
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}
