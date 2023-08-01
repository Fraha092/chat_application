import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ContactList.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Login and Authentication'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.phone,
              //obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login();
              },
              child: Text('App Login'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _login() async {
    final headers = {'Accept': 'application/json'};
    final apiUrl = 'http://svkraft.shop/api/login';

    final request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.fields.addAll({
      'phone': _phoneController.text,
      'password': _passwordController.text,
    });

    request.headers.addAll(headers);

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.bytesToString();
      final loginResponse = jsonDecode(responseData);

      final bool success = loginResponse['success'];
      final String message = loginResponse['message'];

      if (success){
        final data = loginResponse['data'];
        final String token = data['token'];
        final user = data['user'];
        final int id = user['id'];
        final String name = user['name'];
        final String username = user['username'];
        final String email = user['email'];
        final String phone = user['phone'];
        final String location = user['location'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContactList(),
          ),
        );
        print('Login successful. Token: $token');
        print('User ID: $id');
        print('Name: $name');
        print('Username: $username');
        print('Email: $email');
        print('Phone: $phone');
        print('Location: $location');
      } else {
        print('Login failed. Message: $message');
      }
    } else {
      print(response.reasonPhrase);
    }
  }
}
