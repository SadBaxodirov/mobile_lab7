import 'package:http/http.dart' as http;

void fetchData() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print('Title: ${response.body}');
  } else {
    print('Error: ${response.statusCode}');
  }
}

void main() {
  fetchData();
}
