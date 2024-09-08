import 'package:flutter/material.dart';
import 'package:hospital_management/stateful_screens.dart/update_stock.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';
import 'dart:io';

class ViewItems extends StatefulWidget {
  final String hospital_id;
  ViewItems({required this.hospital_id});

  @override
  State<ViewItems> createState() => _ViewItemsState();
}

class _ViewItemsState extends State<ViewItems> {

         HttpClient _createHttpClient() {
    final httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    return httpClient;
    }

       List products = [];
Future<void> fetchData() async {
  // Simulate a delay (e.g., fetching data from an API)
  setState(() {
    _isLoading = true;
  });
      final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/hospital/allitems');
                  
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
                products = newArr;
               print(products);  
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
            title: Text("All Items"),
          ),
          body: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(products[index]['itemName']),
                subtitle: Text("Available Stock: " + products[index]['stock']),
                trailing: ElevatedButton(onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UpdateStock(
                        item_id: products[index]['_id'],
                        stock: products[index]['stock']
                      )),
                    );
                }, child: Text("Update Stock")),
              );
            },
          ),
        ),
      ],
    );
  }
}