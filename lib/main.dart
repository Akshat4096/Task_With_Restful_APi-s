import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_with_resful/widget/cardWidget.dart';
import 'AddpageScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
       theme: ThemeData.dark(),
       home: homepage(),
    );
  }
}

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  bool isloading = false;
  List items = [];
  @override
  void initState(){
    super.initState();
    fetchTask();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Crud with Restful',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20
          ),),
        ),
      body:Visibility(
        visible: isloading,
        child: Center(
          child: CircularProgressIndicator(),
        ),
        replacement: RefreshIndicator(
          onRefresh:fetchTask ,
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index] as Map;
              // final id = item['_id'] as String;
            return CardWidget(
                index: index,
                item: item,
                NavigateToAddPage: NavigateToAddPage,
                DeleteById: DeleteById
            );
          },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Addpage(),));
        },
        label: Text('Add Task'),
      ),
    );
  }
  Future<void> fetchTask() async{
    final Url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri = Uri.parse(Url);
    final response =await http.get(uri);

    if(response.statusCode==200){
      final json = jsonDecode(response.body) as Map;
      final result = json['items'] as List;
      setState(() {
        items = result ;
      });
    } else{}
    setState(() {
      isloading = false;
    });
    // print(response.body);
  }

  Future<void> DeleteById(String id) async {
        final Url = 'https://api.nstack.in/v1/todos/${id}';
        final uri = Uri.parse(Url);
        final response =await http.delete(uri);

        if(response.statusCode == 200){
          final filtered = items.where((element) => element['_id'] != id).toList();
        setState(() {
          items = filtered;
        });
        } else{
          ShowErrorMessage('Deletion Failed');
        }
  }

  void ShowErrorMessage(String message){
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(
          '${message}',
          style: TextStyle(color: Colors.white,
              fontSize: 20),
        ),
          backgroundColor: Colors.red,
        )
    );
  }

  Future<void> NavigateToAddPage(Map item) async {
    await Navigator.push(context,
      MaterialPageRoute(builder: (context) =>  Addpage(todo : item),));
    setState(() {
      isloading = true;
    });
    fetchTask();
  }
}

