import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital_management/stateful_screens.dart/patient_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';

class InsuranceDetails extends StatefulWidget {

  final String patient_id;
    final String hospital_id;

  InsuranceDetails({required this.patient_id, required this.hospital_id});

  @override
  State<InsuranceDetails> createState() => _InsuranceDetailsState();
}

class _InsuranceDetailsState extends State<InsuranceDetails> {
    final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

    final TextEditingController _insurance_company = TextEditingController();
    final TextEditingController _total_cover = TextEditingController();
    final TextEditingController _goverment_scheme = TextEditingController();
    final TextEditingController _insurance_type = TextEditingController();


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
            title: Text("Add Insurance Details"),
          ),
          body: Column(
            children: [
            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  TextFormField(
                                    controller: _insurance_company,
                                    decoration: InputDecoration(
                                      labelText: 'Insurance Company',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.local_hospital),
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter insurance Company';
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20),
                                
                                  TextFormField(
                                    controller: _total_cover,
                                    decoration: InputDecoration(
                                      labelText: 'Total Cover',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.location_on),
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter total cover';
                                      }
                                      return null;
                                    },
                                  ),
                          
                          
                                  SizedBox(height: 20),
                          
                                  TextFormField(
                                    controller: _goverment_scheme,
                                    decoration: InputDecoration(
                                      labelText: 'Any Goverment Scheme',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.email),
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      return null;
                                    },
                                  ),
                          
                                  SizedBox(height: 20),
                          
                                  TextFormField(
                                    controller: _insurance_type,
                                    decoration: InputDecoration(
                                      labelText: 'Insurance Type',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.add_alert),
                                    ),
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter the Insurance type';
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
                                                
                                                          
                          final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/patient/insurance');
                                
                          final ioClient = IOClient(_createHttpClient());
                                
                          try {
                            final response = await ioClient.post(
                              url,
                          headers: <String, String>{ 
                              'Content-Type': 'application/json; charset=UTF-8', 
                            },  
                            body: jsonEncode({
                              'id': widget.patient_id,
                              'insurance_type': _insurance_type.text,
                              'insurance_company': _insurance_company.text,
                              'total_cover': _total_cover.text,
                              'goverment_scheme': _goverment_scheme.text,
                              }),
                            );
                                
                                
                            if (response.statusCode == 200) {
                              final Map<String, dynamic> responseData = jsonDecode(response.body);
                                
                              print(response.body);        
                          
                          
                              final String errorMessage = 'Insurance Details Added Successfully!';
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Done'),
                                  content: Text(errorMessage),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => PatientDetails(
                                  hospital_id: widget.hospital_id,
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
                                      'Add Insurance',
                                      style: TextStyle(fontSize: 18, color: Colors.white),
                                    ),
                                  ),
                                
                                
                                
                                ],
                              ),
                            ),
            ],
          ),
        ),
      ],
    );
  }
}