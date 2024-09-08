
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';

class AddDoctors extends StatefulWidget {
  final String hospital_id;

  AddDoctors({required this.hospital_id});

  @override
  State<AddDoctors> createState() => _AddDoctorsState();
}

class _AddDoctorsState extends State<AddDoctors> {
  final _formKey = GlobalKey<FormState>();

   HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
  }


  @override
  void initState() {
    super.initState();
  }



  bool _isLoading = false;

  // Controllers to capture form inputs
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController doctorTypeController = TextEditingController();
  final TextEditingController hospitalIdController = TextEditingController();

  String? gender;

  // Submit function
  void _submitForm() async {


setState(() {_isLoading = true;});
                                  
                  
            final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/doctor/add');
                  
            final ioClient = IOClient(_createHttpClient());
                  
            try {
              final response = await ioClient.post(
                url,
            headers: <String, String>{ 
                'Content-Type': 'application/json; charset=UTF-8', 
              },  
              body: jsonEncode({
                'name': nameController.text,
                'phoneNumber': phoneController.text,
                'dob': dobController.text,
                'age': ageController.text,
                'gender': gender,
                'address': addressController.text,
                'doctor_type': doctorTypeController.text,
                'hospital_id': widget.hospital_id
                }),
              );
                  
                  
              if (response.statusCode == 201) {
                final Map<String, dynamic> responseData = jsonDecode(response.body);
                  
                final String errorMessage = 'You can add more doctor now!';
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Doctor Added Successfully!'),
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
                setState(() {
                _isLoading = false;
              });
                  
              } else {
                final String errorMessage = 'Login id/password is incorrect';
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
              setState(() {
                _isLoading = false;
              });
              print("erriyOO");
              print(e);
            }


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
            title: Text('Add Doctor'),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
            
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Name field
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            labelText: 'Doctor Name',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        
                        TextFormField(
                          controller: phoneController,
                          decoration: InputDecoration(
                            labelText: 'Doctor Phone Number',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the phone number';
                            } 
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        
                        TextFormField(
                          controller: dobController,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth (In DD/MM/YYYY)',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the date of birth';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        
                        // Age field
                        TextFormField(
                          controller: ageController,
                          decoration: InputDecoration(
                            labelText: 'Age',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the age';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        
                        DropdownButtonFormField<String>(
                          value: gender,
                          decoration: InputDecoration(
                            labelText: 'Gender',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Male', 'Female', 'Other']
                              .map((gender) => DropdownMenuItem(
                                    value: gender,
                                    child: Text(gender),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              gender = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select the gender';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        
                        // Address field
                        TextFormField(
                          controller: addressController,
                          decoration: InputDecoration(
                            labelText: 'Address',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the address';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        
                        // Doctor type field
                        TextFormField(
                          controller: doctorTypeController,
                          decoration: InputDecoration(
                            labelText: 'Doctor Specialization',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the doctor specialization';
                            }
                            return null;
                          },
                        ),
                        
                      
                        SizedBox(height: 20),
                        
                        // Submit Button
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Submit'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}