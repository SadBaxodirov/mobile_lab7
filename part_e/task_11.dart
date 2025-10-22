import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLoading = false;
  List results = [];
  TextEditingController _date = TextEditingController();
  TextEditingController _code = TextEditingController();
  String date = "";
  String code = "";
  void fetchRates() async {
    if (_date.text.isNotEmpty) {
      date = _date.text;
      if (_code.text.isNotEmpty) {
        code = _code.text;
        final url = Uri.parse(
            'https://cbu.uz/ru/arkhiv-kursov-valyut/json/$code/$date/');
        try {
          final response = await http.get(url);
          final data = jsonDecode(response.body);
          setState(() {
            results = data;
          });
        } catch (e) {
          print(e);
        }
      } else {
        code = "all";
        final url = Uri.parse(
            'https://cbu.uz/ru/arkhiv-kursov-valyut/json/$code/$date/');
        try {
          final response = await http.get(url);
          final data = jsonDecode(response.body);
          setState(() {
            results = data;
          });
        } catch (e) {
          print(e);
        }
      }
    } else {
      final url = Uri.parse('https://cbu.uz/ru/arkhiv-kursov-valyut/json/');
      try {
        final response = await http.get(url);
        final data = jsonDecode(response.body);
        setState(() {
          results = data;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Uzbekistan currency exchange rates')),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : results.isEmpty
                ? Center(
                    child: Column(
                    children: [
                      TextField(
                        controller: _date,
                        decoration: InputDecoration(
                          labelText: 'Date',
                          hintText: 'Enter date (YYYY-MM-DD)',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      TextField(
                        controller: _code,
                        decoration: InputDecoration(
                          labelText: 'Currency code',
                          hintText: 'Enter currency code',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: fetchRates,
                        child: const Text("Fetch rates"),
                      )
                    ],
                  ))
                : Center(
                    child: Column(
                    children: [
                      Expanded(
                          child: ListView.builder(
                        itemCount: results.length,
                        itemBuilder: (context, index) {
                          final currency = results[index];
                          return ListTile(
                            leading: Text(currency["Ccy"]),
                            title: Text(currency["CcyNm_UZ"]),
                            subtitle: Text("Rate: ${currency["Rate"]}"),
                            trailing: Text(currency["Date"]),
                          );
                        },
                      )),
                      ElevatedButton(
                          onPressed: () {
                            setState(() {
                              results = [];
                            });
                          },
                          child: Text("Back"))
                    ],
                  )));
  }
}
