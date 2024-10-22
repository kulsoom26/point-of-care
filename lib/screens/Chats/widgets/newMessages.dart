import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/patient.dart';
import 'package:test/providers/radiologist.dart';

class NewMessage extends StatefulWidget {
  final userId;
  final receiverId;
  NewMessage(this.userId, this.receiverId);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }
    FocusScope.of(context).unfocus();
    _messageController.clear();

    final user = Provider.of<Auth>(context, listen: false);

    final type;

    if (user.role == 'Doctor') {
      type =
          Provider.of<Doctor>(context, listen: false).getDoctor(user.userId!);
    } else if (user.role == 'Patient') {
      type =
          Provider.of<Patient>(context, listen: false).getPatient(user.userId!);
    } else {
      type = Provider.of<Radiologist>(context, listen: false)
          .getRadiologist(user.userId!);
    }

    List<String> ids = [user.userId.toString(), widget.receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .collection('messages')
        .add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': user.userId,
      'username': user.userName,
      'userImage': type.image
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
              child: TextField(
            controller: _messageController,
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(labelText: "Send a message..."),
          )),
          IconButton(
              onPressed: _submitMessage,
              color: primaryColor,
              icon: Icon(Icons.send))
        ],
      ),
    );
  }
}
