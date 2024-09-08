import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';
import 'package:hospital_management/stateful_screens.dart/schedule_appointment.dart';


class Apointment extends StatefulWidget {
  final String hospital_id;

  Apointment({required this.hospital_id});

  @override
  State<Apointment> createState() => _ApointmentState();
}

class _ApointmentState extends State<Apointment> {

     HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
    }

        List doctors = [];
Future<void> fetchData() async {
  // Simulate a delay (e.g., fetching data from an API)
  setState(() {
    _isLoading = true;
  });
      final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/doctor/');
                  
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
                  if(responseData[i]['hospital_id'] == widget.hospital_id) {
                    newArr.add(responseData[i]);
                  }
                }
                doctors = newArr;      
                print(doctors);  
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Doctors List'),
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(doctors[index]['name']),
            subtitle: Text(doctors[index]['doctor_type']),
            onTap: () {
              // Handle tap if needed
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on ${doctor.name}')),
              );
            },
            trailing: ElevatedButton(onPressed: () {
                                
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ScheduleApointment(
                    doctor_id: doctors[index]['_id'],
                    hospital_id: widget.hospital_id,
                    doctor_name: doctors[index]['name'],
                    doctor_type: doctors[index]['doctor_type'],
                  )),
                );
            }, child: Text("Schedule An Appointment")),
          );
        },
      ),
    );

  }
}