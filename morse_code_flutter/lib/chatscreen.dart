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
}