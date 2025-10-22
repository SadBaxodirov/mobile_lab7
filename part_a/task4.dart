import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void fetchData() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final response = await http.get(url);
  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    print('First: ${data[0]}');
  } else {
    print('Error: ${response.statusCode}');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List posts = [];

  void fetchData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        posts = data;
      });
    } else {
      setState(() {
        posts = ['Error: ${response.statusCode}'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Fetch data from api endpoint')),
          body: posts.isEmpty
              ? Center(
                  child: ElevatedButton(
                      onPressed: fetchData, child: Text("Press to fetch data")),
                )
              : ListView.builder(
                  itemCount: posts.length, // Number of items in the list
                  itemBuilder: (BuildContext context, int index) {
                    final post = posts[index];
                    return ListTile(
                      title: Text(post["title"]),
                      subtitle: Text(post["body"]),
                    );
                  },
                )),
    );
  }
}
