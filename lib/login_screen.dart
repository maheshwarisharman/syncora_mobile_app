import 'dart:io';
import 'package:flutter/material.dart';
import 'sign_up_screen.dart';
import 'home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:http/io_client.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();


}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            SizedBox(height: 100),
            Image.network(
              'https://i.imgur.com/kbZdiSR.png', 
              width: 350,
              height: 350,
            ),
              SizedBox(height: 20),
              Container(
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _phoneController,
                          decoration: InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone_android),
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone Number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                      
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.lock),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
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
                                      
                      
                final String phoneNumber = _phoneController.text;
                final String password = _passwordController.text;
                      
                print(phoneNumber);
                print(password);
                      
                final Uri url = Uri.parse('https://health-management-backend.vercel.app/api/auth/login');
                      
                final ioClient = IOClient(_createHttpClient());
                      
                try {
                  final response = await ioClient.post(
                    url,
                headers: <String, String>{ 
                    'Content-Type': 'application/json; charset=UTF-8', 
                  },  
                  body: jsonEncode({
                    'phoneNumber': phoneNumber,
                    'password': password,
                    }),
                  );
                      
                      
                  if (response.statusCode == 200) {
                    final Map<String, dynamic> responseData = jsonDecode(response.body);
                      
                    print(response.body);             
                      
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeScreen(
                        phoneNumber: phoneNumber,
                      )),
                    );
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
                  print("erriyOO");
                  print(e);
                }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.406, vertical: 15),
                            backgroundColor: Color(0XFF8093ff), 
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Don't have an account? "),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                                );
                              },
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Color(0XFF8093ff),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      
                      
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),]
    );
  }
}
