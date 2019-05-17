import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lamp/lamp.dart';
import 'package:flutter/services.dart';

class ChatScreenStateful extends StatefulWidget {
  
  final ChatRoom chatroom;

  ChatScreenStateful({Key key, @required this.chatroom}) : super(key: key);
  
  @override
  ChatScreen createState() {
    return ChatScreen(chatroom: chatroom);
  }
}

class ChatScreen extends State {

  static final dotTime = 30;
  static final dashTime = 150;
  static final slashTime = 600;
  static final spaceTime = 2000;
  static final sendTime = 4000;

  String message = "";
  int tapDownTime = 0;
  int tapUpTime = 0;

  int lastMessage = 0;
  final ChatRoom chatroom;

  // receive data from the FirstScreen as a parameter
  ChatScreen({@required this.chatroom});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(chatroom.name)),
      body: _buildBody(context),
      floatingActionButton: new GestureDetector(
        onTapDown: (tapDownDetails) {
          setState(() {
            tapDownTime = new DateTime.now().millisecondsSinceEpoch;
          });

          if (tapUpTime != 0) {
            String character = "";
            int timeSinceTapUp = tapDownTime - tapUpTime;
            if (timeSinceTapUp > spaceTime) {
              character = "//";
            } else if (timeSinceTapUp > slashTime) {
              character = "/";
            }
            setState(() {
              message = message + character;
            });
          }
        },
        onTapUp: (tapUpDetails) async {
          setState(() {
            tapUpTime = new DateTime.now().millisecondsSinceEpoch;
          });

          String character;
          if (tapUpTime - tapDownTime > dashTime){
            character = "-";
          }else{
            character = ".";
          }
          setState(() {
            message = message + character;
          });

          await new Future.delayed(Duration(milliseconds: sendTime));
          int timeNow = new DateTime.now().millisecondsSinceEpoch;
          if (timeNow - tapDownTime > sendTime){
            setState(() {
              Firestore.instance.collection('messages').add(<String, dynamic> {
                "added_at": timeNow,
                "text": message,
                "chatroom": chatroom.reference
              });
              message = "";
            });
          }
        },
        child: new Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          width: 800.0,
          height: 100.0,
          child: new Container(
            color: Colors.blue,
            child: new Text(
              message,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(BuildContext context) {

    var messagesQuery = Firestore.instance.collection('messages')
        .where("chatroom", isEqualTo: chatroom.reference)
        .orderBy('added_at', descending: true);

    return StreamBuilder<QuerySnapshot>(
      stream: messagesQuery.snapshots(),
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
        child: new RawMaterialButton(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: ListTile(
                title: Text(message.toString())
            ),
          ),
          onPressed: () async {
            await play(message.toString());
          },
        ));
  }

  static Future play(String messageString) async{
    for (int i = 0; i < messageString.length; i++) {
      var character = messageString[i];
      if (character == "."){
        await playDot();
      }else if (character == "-"){
        await playDash();
      }else if (character == "/"){
        await playSlash();
      }
    }
  }
  static const MethodChannel _channel = const MethodChannel('vibrate');

  static Duration dotTimeDuration = Duration(milliseconds: dotTime);
  static Future playDot() async {
    print(".");
    Lamp.turnOn();
    _channel.invokeMethod('vibrate', {"duration": dotTime});
    return new Future.delayed(dotTimeDuration).then((_) {
      return Lamp.turnOff();
    });
  }

  static Duration dashTimeDuration = Duration(milliseconds: dashTime);
  static Future playDash() async {
    Lamp.turnOn();
    _channel.invokeMethod('vibrate', {"duration": dashTime});
    return new Future.delayed(dashTimeDuration ).then((_) {
      return Lamp.turnOff();
    });
  }

  static Duration slashTimeDuration = Duration(milliseconds: slashTime);
  static Future playSlash() async {
    print("/");
    return new Future.delayed(Duration(milliseconds: slashTime));
  }

}

class Message {
  DocumentReference reference;
  DocumentReference chatroom;
  String text;
  int added;
  static int lastMessage = new DateTime.now().millisecondsSinceEpoch;

  Message.fromMap(Map<String, dynamic> map, {this.reference}){
      assert(map['text'] != null);
      text = map['text'];
      assert(map['chatroom'] != null);
      chatroom = map['chatroom'];
      assert(map['added_at'] != null);
      added = map['added_at'];
      if(lastMessage != 0 && added > lastMessage){
        lastMessage = added;
        ChatScreen.play(text);
      }
  }

  Message.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => text;
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