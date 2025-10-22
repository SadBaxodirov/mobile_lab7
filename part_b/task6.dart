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
  List posts = [];
  bool isLoading = false;
  String? errorMessage;

  void fetchData() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posta');
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          posts = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Error: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      // For example, no internet or invalid response
      setState(() {
        errorMessage = 'Network error: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(title: Text('Fetch data from api endpoint')),
          body: isLoading
              ? Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(
                      child: Column(
                        children: [
                          Text(errorMessage!),
                          ElevatedButton(
                              onPressed: fetchData, child: Text("Retry"))
                        ],
                      ))
                  : posts.isEmpty
                      ? Center(
                          child: ElevatedButton(
                              onPressed: fetchData,
                              child: Text("Press to fetch data")),
                        )
                      : ListView.builder(
                          itemCount:
                              posts.length, // Number of items in the list
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
