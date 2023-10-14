
import 'package:applogin/home/home.dart';
import 'package:applogin/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

import 'package:flutter/material.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  final id = DateTime.now().millisecondsSinceEpoch.toString();
  final ref = FirebaseDatabase.instance.ref('Data');
  final SearchController = TextEditingController();
  final editController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextFormField(
              controller: SearchController,
              decoration: InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onChanged: (String value) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, snapshot, animation, index) {
                final description = snapshot.child('description').value.toString();
                final name = (snapshot.child('Name').value.toString());
                final _image = (snapshot.child('image').value);
                if (SearchController.text.isEmpty) {
                  return ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(snapshot.child('description').value.toString()),
                        Text(
                          snapshot.child('Name').value.toString(),
                          style: const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                    // subtitle: Text(snapshot.child('Name').value.toString()),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          onTap: () {
                            showMyDialog(description, snapshot.child('id').value.toString());
                          },
                          value: 1,
                          child: const ListTile(
                            leading: Icon(Icons.edit),
                            title: Text('Edit'),
                          ),
                        ),
                        PopupMenuItem(
                          onTap: () {
                            ref.child(snapshot.child('id').value.toString()).remove();
                          },
                          value: 2,
                          child: const ListTile(
                            leading: Icon(Icons.delete),
                            title: Text('Delete'),
                          ),
                        ),
                      ],
                    ),
                  );
                } else if (description.toLowerCase().contains(
                          SearchController.text.toLowerCase(),
                        ) ||
                    name.toLowerCase().contains(
                          SearchController.text.toLowerCase(),
                        )) {
                  return ListTile(
                    title: Text(snapshot.child('description').value.toString()),
                    subtitle: Text(snapshot.child('Name').value.toString()),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      )),
    );
  }

  Future<void> showMyDialog(String description, String id) async {
    editController.text = description;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    ref.child(id).update({
                      'description': editController.text.toString(),
                    }).then((value) {
                      Utils().toastMessage('updated ');
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                  },
                  child: const Text('Update')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'))
            ],
            content: Container(
              child: TextFormField(
                controller: editController,
              ),
            ),
            title: const Text('Update'),
          );
        });
  }
}
