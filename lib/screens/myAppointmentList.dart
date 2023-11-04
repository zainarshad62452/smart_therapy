import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:smart_therapy/main.dart';
import 'package:smart_therapy/screens/doctorsScreen.dart';

import '../models/doctorModel.dart';

class MyAppointmentList extends StatefulWidget {
  @override
  _MyAppointmentListState createState() => _MyAppointmentListState();
}

class _MyAppointmentListState extends State<MyAppointmentList> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  String? _documentID;

  Future<void> _getUser() async {
    user = _auth.currentUser;
  }

  Future<void> deleteAppointment(String docID) {
    return FirebaseFirestore.instance
        .collection('PendingAppointments')
        .doc(docID)
        .delete();
  }

  String _dateFormatter(String _timestamp) {
    String formattedDate =
    DateFormat('dd-MM-yyyy').format(DateTime.parse(_timestamp));
    return formattedDate;
  }

  String _timeFormatter(String _timestamp) {
    String formattedTime =
    DateFormat('kk:mm').format(DateTime.parse(_timestamp));
    return formattedTime;
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () {
        deleteAppointment(_documentID!);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Delete"),
      content: Text("Are you sure you want to delete this Appointment?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  _checkDiff(DateTime _date) {
    var diff = DateTime.now().difference(_date).inHours;
    if (diff > 2) {
      return true;
    } else {
      return false;
    }
  }

  _compareDate(String _date) {
    if (_dateFormatter(DateTime.now().toString())
        .compareTo(_dateFormatter(_date)) ==
        0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Column(
          children: [
            Row(
              children: [
                const SizedBox(width: 10),
                Text(
                  'Appointments & Remainders',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
            SizedBox(height: 20.0,),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('PendingAppointments')
                  .orderBy('date')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return snapshot.data!.size == 0
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'No Appointment Scheduled',
                        style: GoogleFonts.lato(
                          color: Colors.grey,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      MaterialButton(
                        color: kMainColor,
                        onPressed: () =>Get.to(()=>DoctorListScreen())
                        ,child: Text("Book Appointment",style: TextStyle(color: Colors.white),),)
                    ],
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.vertical,
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot document = snapshot.data!.docs[index];
                    print(_compareDate(document['date'].toDate().toString()));
                    if (_checkDiff(document['date'].toDate())) {
                      deleteAppointment(document.id);
                    }
                    if(FirebaseAuth.instance.currentUser?.uid == document['userId']){
                      return Card(
                        elevation: 2,
                        child: InkWell(
                          onTap: () {},
                          child: ExpansionTile(
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    document['doctor'],
                                    style: GoogleFonts.lato(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  _compareDate(
                                      document['date'].toDate().toString())
                                      ? "TODAY"
                                      : "",
                                  style: GoogleFonts.lato(
                                      color: Colors.green,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 0,
                                ),
                              ],
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: Text(
                                _dateFormatter(
                                    document['date'].toDate().toString()),
                                style: GoogleFonts.lato(),
                              ),
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 20, right: 10, left: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Patient name: " + document['name'],
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text(
                                              "Time: " +
                                                  _timeFormatter(
                                                    document['date']
                                                        .toDate()
                                                        .toString(),
                                                  ),
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                              ),
                                            ),
                                            Text(
                                              document['appointmentType']=="On Home"?"Home Service":"At Hospital",
                                              style: GoogleFonts.lato(
                                                fontSize: 16,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    !bool.parse(document['isRated'].toString())?
                                    ExpansionTile(title: Text("Give Rating To Doctor"),
                                      children: [
                                        RatingWidget(uid: document['doctorUid'].toString(),id: document['id'].toString(),),
                                      ],):SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }else{
                      return SizedBox();
                    }

                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


class RatingWidget extends StatefulWidget {
  String? uid;
  String? id;
  RatingWidget({this.uid,this.id});

  @override
  _RatingWidgetState createState() => _RatingWidgetState();
}

class _RatingWidgetState extends State<RatingWidget> {
  double _rating = 0.0;

  Future<void> _saveRatingToFirestore() async {
    try {
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(widget.uid)
          .update({'rating': _rating});
      await FirebaseFirestore.instance
          .collection('PendingAppointments')
          .doc(widget.id)
          .update({'isRated': true});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rating saved successfully.'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving rating.'),
        ),
      );
    }
  }

  Widget _buildStar(int starIndex) {
    return IconButton(
      onPressed: () {
        setState(() {
          _rating = starIndex + 1;
        });
      },
      icon: Icon(
        starIndex < _rating ? Icons.star : Icons.star_border,
        color: Colors.indigo,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) => _buildStar(index)),
        ),
        MaterialButton(
          color: Colors.tealAccent.shade700,
          textColor: Colors.white,
          onPressed: _rating > 0 ? _saveRatingToFirestore : null,
          child: Text('Submit Rating'),
        ),
      ],
    );
  }
}

