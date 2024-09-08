import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital_management/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';


class RegisterHospital extends StatefulWidget {
  final String phoneNumber;


  RegisterHospital({required this.phoneNumber});

  @override
  State<RegisterHospital> createState() => _RegisterHospitalState();
}

class _RegisterHospitalState extends State<RegisterHospital> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneNumber = TextEditingController();
  final TextEditingController _hospitalName = TextEditingController();
  final TextEditingController _hospitalAddress = TextEditingController();
  final TextEditingController _ambulanceHelpline = TextEditingController();
  final TextEditingController _emailAddress = TextEditingController();

  bool _isLoading = false;

    HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
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
            title: Text("Register Hospital"),
          ),
          body: Column(
            children: [
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    children: [
                      SizedBox(height: 30,),
                      Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _hospitalName,
                                decoration: InputDecoration(
                                  labelText: 'Hospital Name',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.local_hospital),
                                ),
                                keyboardType: TextInputType.name,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your hospital name';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 20),
                            
                              TextFormField(
                                controller: _hospitalAddress,
                                decoration: InputDecoration(
                                  labelText: 'Hospital Address',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.location_on),
                                ),
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your hospital address';
                                  }
                                  return null;
                                },
                              ),
                      
                      
                              SizedBox(height: 20),
                      
                              TextFormField(
                                controller: _emailAddress,
                                decoration: InputDecoration(
                                  labelText: 'Hospital Email Address',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.email),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Email Id';
                                  }
                                  return null;
                                },
                              ),
                      
                              SizedBox(height: 20),
                      
                              TextFormField(
                                controller: _ambulanceHelpline,
                                decoration: InputDecoration(
                                  labelText: 'Ambulance HelplineNumber',
                                  border: OutlineInputBorder(),
                                  prefixIcon: Icon(Icons.add_alert),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter the phone Number';
                                  }
                                  return null;
                                },
                              ),
                      
                      
                              SizedBox(height: 30),
                      
                      
                            
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    // Process the login data
                                      setState(() {_isLoading = true;});
                                            
                            
                      final String hospitalName = _hospitalName.text;
                      final String hospitalAddress = _hospitalAddress.text;
                      final String ambulanceHelpline = _ambulanceHelpline.text;
                      final String emailAddress = _emailAddress.text;
                      
                            
                      final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/hospital/register');
                            
                      final ioClient = IOClient(_createHttpClient());
                            
                      try {
                        final response = await ioClient.post(
                          url,
                      headers: <String, String>{ 
                          'Content-Type': 'application/json; charset=UTF-8', 
                        },  
                        body: jsonEncode({
                          'hospitalName': hospitalName,
                          'address': hospitalAddress,
                          'emailAddress': emailAddress,
                          'ambulanceHelpline': ambulanceHelpline,
                          'phoneNumber': widget.phoneNumber,
                          // 'password': password,
                          }),
                        );
                            
                            
                        if (response.statusCode == 201) {
                          final Map<String, dynamic> responseData = jsonDecode(response.body);
                            
                          print(response.body);        
                      
                      
                          final String errorMessage = 'Hospital Sent for Approval Successfully!';
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text('Registered'),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                  onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomeScreen(
                              phoneNumber: widget.phoneNumber,
                            )),
                          );
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
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  backgroundColor: Colors.pinkAccent, // Button color
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                                child: Text(
                                  'Register Hospital',
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                ),
                              ),
                            
                      
                            
                            
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}