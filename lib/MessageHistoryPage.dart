//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
//
// class Message {
//   final int userId;
//   final String message;
//   final String time;
//   final String date;
//
//   Message({
//     required this.userId,
//     required this.message,
//     required this.time,
//     required this.date,
//   });
// }
//
// class MessageHistoryPage extends StatefulWidget {
//   @override
//   _MessageHistoryPageState createState() => _MessageHistoryPageState();
// }
//
// class _MessageHistoryPageState extends State<MessageHistoryPage> {
//   List<Message> _messages = [];
//
//   @override
//   void initState() {
//     super.initState();
//     // Fetch the message history when the page is loaded
//     _fetchMessageHistory();
//   }
//
//   Future<void> _fetchMessageHistory() async {
//     // Replace '{{SVKRAFT}}' with your API endpoint
//     String token='372|wscSqMEI5HZzgwuOQXcmBwJu87YHN9ix2PenlZTh';
//     final headers = {'Accept': 'application/json',
//       'Authorization': 'Bearer $token'
//
//
//     };
//     var url = Uri.parse('http://svkraft.shop/api/sms-history?to_user=20');
//     var response = await http.get(url);
//     response.headers.addAll(headers);
//
//     if (response.statusCode == 200) {
//       // Parse the JSON response and update the messages list
//       Map<String, dynamic> data = jsonDecode(response.body);
//       List<dynamic> messageData = data['data'];
//       setState(() {
//         _messages = messageData
//             .map(
//               (item) => Message(
//             userId: item['userId'],
//             message: item['message'],
//             time: item['time'],
//             date: item['date'],
//           ),
//         )
//             .toList();
//       });
//     } else {
//       print('Failed to fetch message history: ${response.reasonPhrase}');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Message History'),
//       ),
//       body: ListView.builder(
//         itemCount: _messages.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(_messages[index].message),
//             subtitle: Text('Time: ${_messages[index].time} Date: ${_messages[index].date}'),
//           );
//         },
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


import 'dart:convert';

History historyFromJson(String str) => History.fromJson(json.decode(str));

String historyToJson(History data) => json.encode(data.toJson());

class History {
  int statusCode;
  String message;
  List<Datum> data;

  History({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory History.fromJson(Map<String, dynamic> json) => History(
    statusCode: json["status_code"],
    message: json["message"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status_code": statusCode,
    "message": message,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  int userId;
  int isFile;
  String fileType;
  String message;
  String time;
  String date;

  Datum({
    required this.userId,
    required this.isFile,
    required this.fileType,
    required this.message,
    required this.time,
    required this.date,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["userId"],
    isFile: json["is_file"],
    fileType: json["file_type"],
    message: json["message"],
    time: json["time"],
    date: json["date"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "is_file": isFile,
    "file_type": fileType,
    "message": message,
    "time": time,
    "date": date,
  };
}

class MessagingPage extends StatefulWidget {
  @override
  _MessagingPageState createState() => _MessagingPageState();
}

class _MessagingPageState extends State<MessagingPage> {
  List<Datum> messages = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String token='372|wscSqMEI5HZzgwuOQXcmBwJu87YHN9ix2PenlZTh';
    var url = 'http://svkraft.shop/api/sms-history?to_user=20';
    var headers = {'Accept': 'application/json',
      'Authorization': 'Bearer $token'


    };

    try {
      var request = http.Request('GET', Uri.parse(url));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();

        setState(() {
          History history = History.fromJson(jsonDecode(responseBody));
          messages = history.data;
        });
      } else {
        print('Failed to fetch data: ${response.reasonPhrase}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messaging Page'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          Datum message = messages[index];
          return ListTile(
            title: Text('User ID: ${message.userId}'),
            subtitle: Text('Message: ${message.message}'),
            trailing: Text('${message.date} ${message.time}'),
          );
        },
      ),
    );
  }
}

