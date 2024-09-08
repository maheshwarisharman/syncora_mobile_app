import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hospital_management/stateful_screens.dart/patient_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';


class UpdateStock extends StatefulWidget {
  final String item_id;
  final String stock;

  UpdateStock({required this.item_id, required this.stock});

  @override
  State<UpdateStock> createState() => _UpdateStockState();
}

class _UpdateStockState extends State<UpdateStock> {
      final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

    final TextEditingController _newStock = TextEditingController();


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
            title: Text("Update Stock"),
          ),
          body: Column(
            children: [
            SizedBox(height: 40),
            Text("Available Quantity: " + widget.stock),
            SizedBox(height: 20,),
            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                  
                          
                                  TextFormField(
                                    controller: _newStock,
                                    decoration: InputDecoration(
                                      labelText: 'Enter New Inventory',
                                      border: OutlineInputBorder(),
                                      prefixIcon: Icon(Icons.inventory),
                                    ),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      return null;
                                    },
                                  ),

                            SizedBox(height: 20,),

                                  ElevatedButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        // Process the login data
                                          setState(() {_isLoading = true;});
                                                
                                                          
                          final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/hospital/updateitem');
                                
                          final ioClient = IOClient(_createHttpClient());
                                
                          try {
                            final response = await ioClient.post(
                              url,
                          headers: <String, String>{ 
                              'Content-Type': 'application/json; charset=UTF-8', 
                            },  
                            body: jsonEncode({
                              'id': widget.item_id,
                              'stock': _newStock.text,
                              }),
                            );
                                
                                
                            if (response.statusCode == 200) {
                              final Map<String, dynamic> responseData = jsonDecode(response.body);
                                
                              print(response.body);        
                          
                          
                              final String errorMessage = 'Stock Updated Successfully!';
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Done'),
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
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                      backgroundColor: Colors.pinkAccent, // Button color
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30.0),
                                      ),
                                    ),
                                    child: Text(
                                      'Update',
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