import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_therapy/main.dart';
import 'package:smart_therapy/screens/bookingScreen.dart';
import 'package:smart_therapy/screens/login_screen.dart';

import '../models/doctorModel.dart';

class DoctorListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Therapy Doctors"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DoctorListView(),
      ),
    );
  }
}

class DoctorListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: therapyDoctors.length,
      itemBuilder: (context, index) {
        return DoctorListTile(doctor: therapyDoctors[index]);
      },
    );
  }
}

class DoctorListTile extends StatelessWidget {
  final Doctor doctor;

  DoctorListTile({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Add elevation for a shadow effect
      margin: EdgeInsets.only(bottom: 16), // Add margin between list tiles
      child: ListTile(
        contentPadding: EdgeInsets.all(16), // Add padding inside the ListTile
        title: Text(doctor.docName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(doctor.clinicName),
            Text(doctor.address),
          ],
        ),
        trailing: MaterialButton(onPressed: ()
        {
          if(FirebaseAuth.instance.currentUser !=null){
          Get.to(()=>BookingScreen(doctor: doctor.docName,));
          }else{
            showDialog(context: context, builder: (ctx)=>AlertDialog(title: Text("Please login inorder to book an Appointment"),actions: [
              TextButton(onPressed: ()=>Get.to(()=>const LoginScreen()), child: Text("Login")),
              TextButton(onPressed: ()=>Navigator.pop(context), child: Text("Cancel")),
            ],));
          }
        },child: Text("Book Appointment",style: TextStyle(color: Colors.white),),color: kMainColor,),
      ),
    );
  }
}