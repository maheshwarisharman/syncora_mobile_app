import 'package:flutter/material.dart';
import 'package:hospital_management/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';


class ScheduleApointment extends StatefulWidget {
  final String doctor_id;
  final String hospital_id;
  final String doctor_name;
  final String doctor_type;

  ScheduleApointment({required this.doctor_id, required this.hospital_id, required this.doctor_name, required this.doctor_type});

  @override
  State<ScheduleApointment> createState() => _ScheduleApointmentState();
}

class _ScheduleApointmentState extends State<ScheduleApointment> {

  final _formKey = GlobalKey<FormState>();


  final TextEditingController _patientName = TextEditingController();
  final TextEditingController _patientPhoneNumber = TextEditingController();
  final TextEditingController _time = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _age = TextEditingController();
  final TextEditingController _emergencyContactNumber = TextEditingController();
  final TextEditingController _patientType = TextEditingController();


  bool _isLoading = false;

    HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Schedule An Appointment"),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            Center(
              child: Text("You are scheduling an appointment with " + widget.doctor_name , style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold
            ),),
            ),
            Text("Doctor Type Is: " + widget.doctor_type, style: TextStyle(
              fontSize: 16
            ),),



                // Patient Name
                TextFormField(
                  controller: _patientName,
                  decoration: InputDecoration(labelText: 'Patient Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient name';
                    }
                    return null;
                  },
                ),
                // Patient Phone Number
                TextFormField(
                  controller: _patientPhoneNumber,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the phone number';
                    }
                    return null;
                  },
                ),
                // Time
                TextFormField(
                  controller: _time,
                                decoration: InputDecoration(
                                  labelText: 'Time',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.punch_clock_outlined),
                                ),                  
                ),
                // Date
                TextFormField(
                  controller: _date,
                  decoration: InputDecoration(labelText: 'Date'),
                ),
                // Address
                TextFormField(
                  controller: _address,
                  decoration: InputDecoration(labelText: 'Address'),
                ),
                // Date of Birth (DOB)
                TextFormField(
                  controller: _dob,
                  decoration: InputDecoration(labelText: 'Date of Birth'),
                ),
                // Gender
                TextFormField(
                  controller: _gender,
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                // Age
                TextFormField(
                  controller: _age,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: 'Age'),
                ),
                // Emergency Contact Number
                TextFormField(
                  controller: _emergencyContactNumber,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: 'Emergency Contact Number'),
                ),
                // Patient Type
                TextFormField(
                  controller: _patientType,
                  decoration: InputDecoration(labelText: 'Patient Type'),
                ),
                SizedBox(height: 20),
                // Submit Button
                ElevatedButton(
                  onPressed: () async {

                      if (_isLoading == false) {
                                    // Process the login data
                                      setState(() {_isLoading = true;});
                            
                      final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/patient/add');
                            
                      final ioClient = IOClient(_createHttpClient());
                            
                      try {
                        final response = await ioClient.post(
                          url,
                      headers: <String, String>{ 
                          'Content-Type': 'application/json; charset=UTF-8', 
                        },  
                        body: jsonEncode({
                          'hospitalId': widget.hospital_id,
                          'address': _address.text,
                          'phoneNumber': _patientPhoneNumber.text,
                          'dob': _dob.text,
                          'age': _age.text,
                          'gender': _gender.text,
                          'emergergencyContantNumber': _emergencyContactNumber.text,
                          'patientType': _patientType.text,
                          'name': _patientName.text
                          }),
                        );
                                                      print(response.statusCode);        

                            
                        if (response.statusCode == 201 ) {
                          final Map<String, dynamic> responseData = jsonDecode(response.body);
                            
                          print(response.body);        
                      
                      
                          final String errorMessage = 'Appointment Scheduled Successfully!';
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Success'),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                          setState(() {
                            _isLoading = false;
                          });
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                      
                          
                  
                        } else {
                          final String errorMessage = 'Oops! Something went wrong';
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Error'),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    setState(() {
                                      _isLoading = false;
                                    });
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            ),
                          );
                        }
                      } catch(e){
                        print("erriyOO");
                        print(e);
                      }
                    }



                  },
                  child: Text('Submit'),
                ),

          ]
        ),
      ),
    );
  }
}