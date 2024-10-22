import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:test/screens/Chats/widgets/chatBubble.dart';

class ChatMessage extends StatelessWidget {
  final userId;
  final receiverId;
  ChatMessage(this.userId, this.receiverId);

  @override
  Widget build(BuildContext context) {
    List<String> ids = [userId.toString(), receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chatRooms')
            .doc(chatRoomId)
            .collection("messages")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text("No messages found."),
            );
          }

          if (chatSnapshots.hasError) {
            return const Center(
              child: Text("Something went wrong..."),
            );
          }

          final loadedMessages = chatSnapshots.data!.docs;

          return ListView.builder(
              reverse: true,
              padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
              itemCount: loadedMessages.length,
              itemBuilder: (ctx, index) {
                final chatMessage = loadedMessages[index].data();
                final nextChatMessage = index + 1 < loadedMessages.length
                    ? loadedMessages[index + 1].data()
                    : null;
                final currentMessageUserId = chatMessage['userId'];
                final nextMessageUserId =
                    nextChatMessage != null ? nextChatMessage['userId'] : null;
                final nextUserIsSame =
                    nextMessageUserId == currentMessageUserId;

                if (nextUserIsSame) {
                  return MessageBubble.next(
                      message: chatMessage['text'],
                      isMe: userId == currentMessageUserId);
                } else {
                  return MessageBubble.first(
                      userImage: chatMessage['userImage'],
                      username: chatMessage['username'],
                      message: chatMessage['text'],
                      isMe: userId == currentMessageUserId);
                }
              });
        });
  }
}
