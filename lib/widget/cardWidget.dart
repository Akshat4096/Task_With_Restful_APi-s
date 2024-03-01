import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final int index;
  final Map item ;
  final Function(Map) NavigateToAddPage ;
  final Function(String) DeleteById;


  const CardWidget({super.key ,
    required this.index,
    required this.item,
    required this.NavigateToAddPage,
    required this.DeleteById,
  });

  @override
  Widget build(BuildContext context) {
    final id = item['_id'];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListTile(
          leading: CircleAvatar(child: Text('${index + 1}'),),
          title: Text(item['title'],),
          subtitle: Text(item['description']),
          trailing: PopupMenuButton(
            onSelected: (value){
              if(value == 'edit'){
                NavigateToAddPage(item);
              }
              else if(value =='delete'){
                DeleteById(id);
              }
            },
            itemBuilder: (context){
              return [
                PopupMenuItem(
                  child: Text('Edit'),
                  value: 'edit',
                ),
                PopupMenuItem(
                  child: Text('Delete'),
                  value: 'delete',
                ),
              ];
            },
          ),
        ),
      ),
    );
  }
}
