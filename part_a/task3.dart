import 'dart:convert';

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
  fetchData();
}
