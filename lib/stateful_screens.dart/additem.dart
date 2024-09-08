import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';

class AddInventory extends StatefulWidget {
  final String hospital_id;

  AddInventory({required this.hospital_id});


  @override
  State<AddInventory> createState() => _AddInventoryState();
}

class _AddInventoryState extends State<AddInventory> {

    final _formKey = GlobalKey<FormState>();

   HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
  }

    bool _isLoading = false;

    final TextEditingController _itemName = TextEditingController();
  final TextEditingController _stock = TextEditingController();
  final TextEditingController _itemType = TextEditingController();
  final TextEditingController _price = TextEditingController();

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
            title: Text('Add Pharmacy Item'),
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
                        TextFormField(
                          controller: _itemName,
                          decoration: InputDecoration(
                            labelText: 'Item Name',
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
                          controller: _stock,
                          decoration: InputDecoration(
                            labelText: 'Total Stock',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the stock';
                            } 
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        
                        // Date of birth field
                        TextFormField(
                          controller: _itemType,
                          decoration: InputDecoration(
                            labelText: 'Item Type',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the type of item';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        
                        // Age field
                        TextFormField(
                          controller: _price,
                          decoration: InputDecoration(
                            labelText: 'Price',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the price';
                            }
                            return null;
                          },
                        ),
                        
                        // Submit Button
                        ElevatedButton(
                          onPressed: () async {


                              setState(() {_isLoading = true;});
                  
            final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/hospital/additem');
                  
            final ioClient = IOClient(_createHttpClient());
                  
            try {
              final response = await ioClient.post(
                url,
            headers: <String, String>{ 
                'Content-Type': 'application/json; charset=UTF-8', 
              },  
              body: jsonEncode({
                'itemName': _itemName.text,
                'stock': _stock.text,
                'itemType': _itemType.text,
                'price': _price.text,
                'hospital_id': widget.hospital_id,
                }),
              );

              print(response.body);
                  
                  
              if (response.statusCode == 201) {
                final Map<String, dynamic> responseData = jsonDecode(response.body);
                  
                final String errorMessage = 'Item Added Successfully!';
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
                setState(() {
                _isLoading = false;
              });
                  
              } else {
                final String errorMessage = 'An unexpected error occured';
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
                          },
                          child: Text('Add Item'),
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