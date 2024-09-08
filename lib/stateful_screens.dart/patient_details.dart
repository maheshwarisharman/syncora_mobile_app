import 'package:flutter/material.dart';
import 'package:hospital_management/stateful_screens.dart/insurance_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';

class PatientDetails extends StatefulWidget {
  final String hospital_id;

  PatientDetails({required this.hospital_id});

  @override
  State<PatientDetails> createState() => _PatientDetailsState();
}

class _PatientDetailsState extends State<PatientDetails> {

       HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
    }

       List patients = [];
Future<void> fetchData() async {
  // Simulate a delay (e.g., fetching data from an API)
  setState(() {
    _isLoading = true;
  });
      final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/patient/');
                  
            final ioClient = IOClient(_createHttpClient());
                  
            try {
              final response = await ioClient.get(
                url,
            headers: <String, String>{ 
                'Content-Type': 'application/json; charset=UTF-8', 
              },);

                  
              if (response.statusCode == 200) {
                final List<dynamic> responseData = jsonDecode(response.body);
                List newArr = [];
                for (var i = 0; i < responseData.length; i++) {
                  if(responseData[i]['hospitalId'] == widget.hospital_id) {
                    newArr.add(responseData[i]);
                  }
                }
                print(patients);  
                patients = newArr;
                setState(() {
                  _isLoading = false;
                });
                  
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

    bool _isLoading = false;

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
            title: Text("All Patients"),
          ),
          body: ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patient = patients[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(patients[index]['name']),
                trailing: ElevatedButton(onPressed: () {
                                    
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => InsuranceDetails(
                        patient_id: patients[index]['_id'],
                        hospital_id: widget.hospital_id
                      )),
                    );
                }, child: Text("Add Insurance Details")),
              );
            },
          ),
        ),
      ],
    );
  }
}