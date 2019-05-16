// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  SmsSender sender = new SmsSender();
  SmsReceiver receiver = new SmsReceiver();

  static String message = "This is a test message!";
  static String jakesNumber = "6164506289";
  List<String> recipents = [jakesNumber];

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => print('tap!'),
      onLongPress: () => print('long press!')
    );
  }

  void _sendSMS(String message, List<String> recipients){
    sender.sendSms(new SmsMessage(recipents[0], message));
  }
}