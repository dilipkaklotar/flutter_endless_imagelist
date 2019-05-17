import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    title: 'Endless Imageload',
    theme: ThemeData(
        primarySwatch: Colors.blue
    ),
    home: Home(),

  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> imageList = new List();
  ScrollController scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    load10time();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        load10time();
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Endless Image Load'),
      ),
      body: ListView.builder(
          controller: scrollController,
          itemCount: imageList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              constraints: BoxConstraints.tightFor(height: 170.0),
              child: Image.network(imageList[index], fit: BoxFit.fitWidth,),
            );
          }
      ),

    );
  }

  fetch() async {
    final response = await http.get("https://dog.ceo/api/breeds/image/random");
    if (response.statusCode == 200) {
      setState(() {
        imageList.add(json.decode(response.body)['message']);
      });
    } else {
      throw Exception('Failed to load image');
    }
  }

  load10time() {
    for (int i = 0; i < 5; i++) {
      fetch();
    }
  }
}
