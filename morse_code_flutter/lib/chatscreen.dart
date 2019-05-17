import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {

  final ChatRoom chatroom;

  // receive data from the FirstScreen as a parameter
  ChatScreen({Key key, @required this.chatroom}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(chatroom.name)),
      body: _buildBody(context),
      floatingActionButton: new FloatingActionButton(
        onPressed: () {

        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('messages')
          .where("chatroom", isEqualTo: chatroom.reference)
          .orderBy('added_at', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return buildMessagesWidget(context, snapshot.data.documents);
      },
    );
  }


  Widget buildMessagesWidget(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      padding: const EdgeInsets.only(top: 20.0),
      children: snapshot.map((data) => buildMessageWidget(context, data)).toList(),
    );
  }

  Widget buildMessageWidget(BuildContext context, DocumentSnapshot data) {
    final message = Message.fromSnapshot(data);

    return Padding(
        key: ValueKey(message.text),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: ListTile(
              title: Text(message.toString())         ),
        ));
  }


}

class Message {
  final DocumentReference reference;
  final DocumentReference chatroom;
  final String text;

  Message.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['text'] != null),
        text = map['text'],
        assert(map['chatroom'] != null),
        chatroom = map['chatroom'];

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "$text|" + chatroom.documentID;
}

class ChatRoom {
  final String name;
  final DocumentReference reference;

  ChatRoom.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        name = map['name'];

  ChatRoom.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "ChatRoom<$name>";
}