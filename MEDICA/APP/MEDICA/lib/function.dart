import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

var data;
String output_api = 'No accident detected';
fetchdata (String url) async {
  final response = await http.get(Uri.parse(url));
  if(response.statusCode == 200){
    data = json.decode(response.body);
    print(data['0']['name']);
    data.forEach((key, value) => print("idx: $key, Hospital: ${value['name']}"));
  }
}