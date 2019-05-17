import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:morse_code_flutter/chatscreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Rooms',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController _textFieldController = TextEditingController();

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Add new Chat Room'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Insert Chat Room name"),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('SUBMIT'),
                onPressed: () {
                  Firestore.instance.collection('chatrooms').add(<String, dynamic> {
                    "name":_textFieldController.text
                  });
                  _textFieldController.clear();
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat Rooms')),
      body: _buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('chatrooms').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return buildChatRoomWidgets(context, snapshot.data.documents);
      },
    );
  }

  Widget buildChatRoomWidgets(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => buildChatRoomWidget(context, data)).toList(),
    );
  }

  Widget buildChatRoomWidget(BuildContext context, DocumentSnapshot data) {
    final chatroom = ChatRoom.fromSnapshot(data);

    return Padding(
      key: ValueKey(chatroom.name),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: ListTile(
          title: Text(chatroom.name),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(chatroom: chatroom),
                ));
          },
      ),
    ));
  }
}
