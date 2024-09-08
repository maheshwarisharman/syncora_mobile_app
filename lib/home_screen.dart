import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital_management/stateful_screens.dart/add_doctors.dart';
import 'package:hospital_management/stateful_screens.dart/additem.dart';
import 'package:hospital_management/stateful_screens.dart/patient_details.dart';
import 'package:hospital_management/stateful_screens.dart/register_hospital.dart';
import 'package:hospital_management/stateful_screens.dart/view_items.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import 'package:hospital_management/stateful_screens.dart/apointment.dart';

class HomeScreen extends StatefulWidget {
  final String phoneNumber;

  HomeScreen({required this.phoneNumber});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool _isLoading = true;
  List<dynamic> hospitals = [];

   HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
  }

Future<void> fetchData() async {
  // Simulate a delay (e.g., fetching data from an API)
      final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/hospital/');
                  
            final ioClient = IOClient(_createHttpClient());
                  
            try {
              final response = await ioClient.get(
                url,
            headers: <String, String>{ 
                'Content-Type': 'application/json; charset=UTF-8', 
              },);


                  
              if (response.statusCode == 200) {
                final List<dynamic> responseData = jsonDecode(response.body);
                final List<dynamic> newHospitals = [];
                for (var i = 0; i < responseData.length; i++) {
                  if (responseData[i]['phoneNumber'] == widget.phoneNumber) {
                    newHospitals.add(responseData[i]);
                  }
                }
                print(newHospitals);      
                if(newHospitals.length == 0) {
                  print("Insdie empty array");
                  hospitals = [{'hospitalName': 'Not Added', 'isApproved': true, '_id': '89283'}];
                }  else {
                     hospitals = newHospitals;     
                }
                print(hospitals);
                setState(() {
                  _isLoading = false;
                });
                print(hospitals[0]['hospitalName']);
                  
              } else {
                setState(() {
                  _isLoading = false;
                });
              }
            } catch (e) {
              print(e);
            }
}

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
         if (_isLoading)
          const Opacity(
            opacity: 0.8,
            child: ModalBarrier(dismissible: false, color: Colors.black),
          ),
if (_isLoading)
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: CircularProgressIndicator()
              )
            ],
          ),

if(_isLoading == false)
        Scaffold(
          appBar: AppBar(
            title: Text("Home Screen"),
            automaticallyImplyLeading: false
          ),
          body: Column(
            children: [
              SizedBox(height: 10,),
              
          
          Container(
            padding: EdgeInsets.all(10), 
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white, 
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(10), 
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, 
                  blurRadius: 6, 
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hospitals[0]['hospitalName'],
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                
                Row(
                  children: [
                    Icon(
          hospitals[0]['isApproved'] ? Icons.check_circle : Icons.cancel,
          color: hospitals[0]['isApproved'] ? Colors.green : Colors.red, 
          size: 20,
                    ),
                    SizedBox(width: 2), 
                    
                    // Approval status text
                    Text(
          hospitals[0]['isApproved'] ? "Approved" : "Not Approved",
          style: TextStyle(
            fontSize: 16,            
            color: hospitals[0]['isApproved'] ? Colors.green : Colors.red, 
            fontWeight: FontWeight.w500,
          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          SizedBox(height: 10),
          
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,  // Square size for button
            height: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: () {
                  
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterHospital(
                    phoneNumber: widget.phoneNumber
                  )),
                );
                  
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0XFF8093ff),
              ),
              child: Text(
                'Register Hospital',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
          
          SizedBox(width: 20,),
          
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,  // Square size for button
            height: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: () {
                  
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddDoctors(
                    hospital_id: hospitals[0]['_id']
                  )),
                );
                  
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0XFF8093ff),
              ),
              child: Text(
                'Add Doctors',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
                  
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,  // Square size for button
            height: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: () {
                  
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Apointment(
                    hospital_id: hospitals[0]['_id']
                  )),
                );
                  
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0XFF8093ff),
              ),
              child: Text(
                'Schedule Appointment',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),

SizedBox(width: 20),

SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,  // Square size for button
            height: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: () {
                  
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PatientDetails(
                    hospital_id: hospitals[0]['_id']
                  )),
                );
                  
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0XFF8093ff),
              ),
              child: Text(
                'Patient Details',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),
                ],
              ),
                              SizedBox(height: 20,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [


SizedBox(
            width: MediaQuery.of(context).size.width * 0.4, 
            height: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: () {
                  
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddInventory(
                    hospital_id: hospitals[0]['_id']
                  )),
                );
                  
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0XFF8093ff),
              ),
              child: Text(
                'Add Pharmacy Item',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),

SizedBox(width: 20,),

SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,  // Square size for button
            height: MediaQuery.of(context).size.width * 0.4,
            child: ElevatedButton(
              onPressed: () {
                  
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewItems(
                    hospital_id: hospitals[0]['_id']
                  )),
                );
                  
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                backgroundColor: Color(0XFF8093ff),
              ),
              child: Text(
                'View Pharmacy Items',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ),
          ),


                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
