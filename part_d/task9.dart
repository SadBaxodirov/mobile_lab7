import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  void postData() async {
    final url = Uri.parse("https://reqres.in/api/posts");
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.post(url,
          body: {"name": "Saddd", "last_name": "smth"},
          headers: {"x-api-key": 'reqres-free-v1'});
      print("Response code: ${response.statusCode}");
      print("Response body: ${response.body}");
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            appBar: AppBar(title: Text('Post data from api endpoint')),
            body: isLoading
                ? Center(child: CircularProgressIndicator())
                : Center(
                    child: ElevatedButton(
                        child: Text("Post data"), onPressed: postData))));
  }
}
