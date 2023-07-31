import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'MessageHistoryPage.dart';

class SendMessage extends StatefulWidget {
  const SendMessage({super.key});

  @override
  State<SendMessage> createState() => _SendMessageState();
}

class _SendMessageState extends State<SendMessage> {



  final TextEditingController _messageController = TextEditingController();
  final List<String> _messages = [];
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
    _initSocketIO();
  }

  void _initSocketIO() {
    socket = IO.io('{{SVKRAFT}}/send-sms', IO.OptionBuilder().setTransports(['websocket']).build());
    socket.onConnect((data) {
      print("Connected to Socket.IO server");
    });

    socket.on('receive_message', (data) {
      _handleIncomingMessage(data);
    });

    socket.connect();
  }

  void _handleIncomingMessage(dynamic data) {
    if (data != null && data['message'] != null) {
      setState(() {
        _messages.add(data['message']);
      });
    }
  }

  void _sendMessage() async {
    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      String token='372|wscSqMEI5HZzgwuOQXcmBwJu87YHN9ix2PenlZTh';
      var headers = {
        'Authorization': 'Bearer $token'
      };
      var request = http.MultipartRequest('POST', Uri.parse('http://svkraft.shop/api/send-sms'));
      request.fields.addAll({
        'to_user': '4',
        'message': message,
      });
      request.headers.addAll(headers);


      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print(await response.stream.bytesToString());
      } else {
        print(response.reasonPhrase);
      }

      socket.emit('send_message', {'message': message});

      setState(() {
        _messages.add('You: $message');
      });

      _messageController.clear();
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Real Time Message'),
            IconButton(onPressed: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MessagingPage(),
                ),
              );
            }, icon: Icon(Icons.history))
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  // @override
  // void dispose() {
  //   socket.disconnect();
  //   super.dispose();
  // }
}
