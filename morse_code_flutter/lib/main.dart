import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ListViews',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: Scaffold(
        appBar: AppBar(title: Text('ListViews')),
        body: BodyLayout(),
      ),
    );
  }
}

class BodyLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _myListView(context);
  }
}

Widget _myListView(BuildContext context) {

  // backing data
  final friends = ['Jake', 'DJ', 'Tyler'];
  final messages = ['hey', 'you', 'what\'s your number'];
  final timeSinceLast = ['15 mins', '6 hrs', 'Thu'];

  return ListView.builder(
    itemCount: friends.length,
    itemBuilder: (context, index) {
      return ListTile(
        leading: Icon(Icons.wb_sunny),
        title: Text(friends[index]),
        subtitle: Text(messages[index]),
        trailing: Text(timeSinceLast[index]),
        onTap: () {
          String friend = friends[index];
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SecondScreen(name: friend,),
              ));
        },
      );
    },
  );

}

class SecondScreen extends StatelessWidget {

  final String name;

  // receive data from the FirstScreen as a parameter
  SecondScreen({Key key, @required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: RaisedButton(
          child: Text(
            'Go Back',
            style: TextStyle(fontSize: 24),
          ),
          onPressed: () {
            _goBackToFirstScreen(context);
          },
        ),
      ),
    );
  }

  void _goBackToFirstScreen(BuildContext context) {
    Navigator.pop(context);
  }
}