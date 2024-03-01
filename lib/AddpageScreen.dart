import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class Addpage extends StatefulWidget {
  final Map? todo ;
   Addpage({super.key, this.todo});
  @override
  State<Addpage> createState() => _AddpageState();
}

class _AddpageState extends State<Addpage> {

  TextEditingController _title = TextEditingController();
  TextEditingController _desc = TextEditingController();

  bool isedit = false;
  @override
  void initState (){
    super.initState();
    final todo = widget.todo ;
    if(todo!= null){
        isedit = true;
        final title = todo['title'];
        final description = todo['description'];
        _title.text = title;
        _desc.text = description;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isedit? 'Edit Task' :'Add Tasks'),
      ),
      body: ListView(
        padding: EdgeInsets.all(30),
        children: [
          TextField(
            controller: _title,
            decoration: InputDecoration(hintText: 'Title'),
          ),
          SizedBox(height: 10,),
          TextField(
            controller: _desc,
            decoration: InputDecoration(hintText: 'Description'),
            keyboardType: TextInputType.multiline,
            maxLines: 6,
            minLines: 5,
          ),
          SizedBox(height: 20,),
          ElevatedButton(
              onPressed: isedit? updateData : submitData,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(isedit? 'Update' : 'Submit'),
              )),

        ],
      ),
    );
  }

  Future<void> updateData () async{
    final todo = widget.todo;
    if(todo == null){
      print('Unable to update data ');
    }
    final id = todo?['_id'];
    final body = {
      'title' : _title.text,
      'description' : _desc.text,
      'is_completed' : false,
    };
    final Url = 'https://api.nstack.in/v1/todos/$id';
    final uri =   Uri.parse(Url);
    final response = await http.put(
        uri,
        body:jsonEncode(body),
        headers: {'Content-Type': 'application/json'}
    );
    if(response.statusCode ==200) {
      ShowSuccessMessage('Update SuccessFully');
    }else{
      ShowErrorMessage('Failed to Add');
    }

  }

Future<void> submitData () async {

    final title = _title.text;
    final desc = _desc.text;
    final body = {
      'title' : title,
      'description' : desc,
      'is_completed' : false ,
    };
    final Url = 'https://api.nstack.in/v1/todos?page=1&limit=10';
    final uri =   Uri.parse(Url);
    final response = await http.post(
      uri,
      body:jsonEncode(body),
      headers: {'Content-Type': 'application/json'}
    );
    if(response.statusCode ==201) {
     ShowSuccessMessage('Add Task Successfully');
    }else{
      ShowErrorMessage('Failed to Add');
    }

    }

    void ShowSuccessMessage(String message){
    _title.text = '';
    _desc.text = '';
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${message}',style: TextStyle(fontSize: 20),)));
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

}
