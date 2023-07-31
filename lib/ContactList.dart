// import 'package:flutter/material.dart';
//
//
// import 'package:http/http.dart' as http;
//
//
// class ContactList extends StatefulWidget {
//   const ContactList({super.key});
//
//   @override
//   State<ContactList> createState() => _ContactListState();
// }
//
// class _ContactListState extends State<ContactList> {
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Contact List'),
//       ),
//       //body:
//     );
//   }
// }
//
//
//
//
//
//
//
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// //
// // class ChatPage extends StatefulWidget {
// //   const ChatPage({super.key});
// //
// //   @override
// //   State<ChatPage> createState() => _ChatPageState();
// // }
// //
// // class _ChatPageState extends State<ChatPage> {
// //   Map<String, dynamic>? contact;
// //
// //   Map<String, String> get headers=>{
// //     'Accept': 'application/json',
// //   };
// //   Future getContactList()async{
// //     var response=await http.get(Uri.parse('http://svkraft.shop/api/chat-list'),headers: headers);
// //     setState(() {
// //       contact = jsonDecode(response.body);
// //       print('contact:::${contact.toString()}');
// //     });
// //   }
// //
// //
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text("Contact list of chat application"),
// //       ),
// //       body: ListView.builder(
// //           shrinkWrap: true,
// //           physics: ScrollPhysics(),
// //           itemCount: 1,
// //           itemBuilder: (BuildContext context, int index){
// //             return ListTile(
// //               leading: CircleAvatar(
// //                 backgroundImage: NetworkImage(contact!['data'][index]['image']),
// //               ),
// //               title: Text(contact!['data'][index]['name']),
// //               //subtitle: Text(contact?['data'][index]['name']),
// //             );
// //           }
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void initState() {
// //
// //     getContactList();
// //     // TODO: implement initState
// //     super.initState();
// //   }
// //
// // }

//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'Shimmer_layout.dart';
// import 'getData_provider.dart';
//
// class ContactList extends StatefulWidget {
//   const ContactList({Key? key}) : super(key: key);
//
//   @override
//   State<ContactList> createState() => _ContactListState();
// }
//
// class _ContactListState extends State<ContactList> {
//   @override
//   void initState() {
//     super.initState();
//     final dataProvider = Provider.of<GetDataProvider>(context, listen: false);
//     dataProvider.getMyData();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final dataProvider = Provider.of<GetDataProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Contact List"),
//       ),
//       body: dataProvider.isLoading
//           ? Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: 5,
//             itemBuilder: (ctx,i){
//               return Column(
//                 children: [
//                   loadingShimmer(),
//                   const SizedBox(height: 10,)
//                 ],
//               );
//             }),
//       ): dataProvider.responseData.data == null ? Center(
//         child: Text('No data Available'),
//       )
//
//           : ListView.builder(
//           shrinkWrap: true,
//           itemCount:  dataProvider.responseData.data!.length,
//           itemBuilder: (ctx, i) {
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Card(
//
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Image.network(dataProvider.responseData.data![i].image,height:100,width: 100,fit: BoxFit.cover,),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(dataProvider.responseData.data![i].name),
//                             const SizedBox(height: 10,),
//                            // Text(dataProvider.responseData.data![i].email!),
//                           ],
//                         ),
//                       ),
//                     ],
//                   )),
//             );
//           }),
//     );
//   }
// }





import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Data Models
// ... (Paste the Contact and Datum classes here)
// To parse this JSON data, do
//
//     final contact = contactFromJson(jsonString);

import 'dart:convert';

import 'Send_message.dart';

Contact contactFromJson(String str) => Contact.fromJson(json.decode(str));

String contactToJson(Contact data) => json.encode(data.toJson());

class Contact {
  int statusCode;
  String message;
  List<Datum> data;

  Contact({
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory Contact.fromJson(Map<String, dynamic> json) => Contact(
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
  String image;
  String name;
  String email;
  String? phone;
  String lastMessage;

  Datum({
    required this.userId,
    required this.image,
    required this.name,
    required this.email,
    this.phone,
    required this.lastMessage,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    userId: json["userId"],
    image: json["image"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    lastMessage: json["last_message"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "image": image,
    "name": name,
    "email": email,
    "phone": phone,
    "last_message": lastMessage,
  };
}

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  List<Datum>? contactList;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    String token='372|wscSqMEI5HZzgwuOQXcmBwJu87YHN9ix2PenlZTh';
    var headers = {'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };
    var request = http.Request('GET', Uri.parse('http://svkraft.shop/api/chat-list'));
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      String responseBody = await response.stream.bytesToString();
      Contact contact = Contact.fromJson(jsonDecode(responseBody));
      setState(() {
        contactList = contact.data;
      });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact List'),
      ),
      body: contactList == null
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemCount: contactList!.length,
        itemBuilder: (context, index) {
          Datum contact = contactList![index];
          return ListTile(
            leading: CircleAvatar(
             // backgroundImage: NetworkImage(contact.image),
            ),
            title: Text(contact.name),
            subtitle: Text(contact.lastMessage),
            onTap: (){
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => SendMessage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
