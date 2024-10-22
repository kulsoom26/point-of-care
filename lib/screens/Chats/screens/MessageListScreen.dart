// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/patient.dart';
import 'package:test/screens/Chats/screens/chatScreen.dart';

// ignore: must_be_immutable
class MessagesScreen extends StatefulWidget {
  static const routeName = '/message-list';

  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  List? messagesProvider;
  List? displayList;
  var user;
  var users;
  @override
  void initState() {
    user = Provider.of<Auth>(context, listen: false);
    messagesProvider = user.role == 'Patient'
        ? Provider.of<Doctor>(context, listen: false).doctors
        : Provider.of<Patient>(context, listen: false).patients;
    users = Provider.of<Auth>(context, listen: false).users;
    displayList = messagesProvider;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Messages",
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      spreadRadius: 2,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: deviceSize.width * 0.3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: "Search",
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 14,
                            ),
                          ),
                          onChanged: (val) {
                            setState(() {
                              displayList = messagesProvider!
                                  .where((element) => element.userName
                                      .toLowerCase()
                                      .contains(val.toLowerCase()))
                                  .toList();
                            });
                          },
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.search,
                      size: 20,
                      color: Colors.black54,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            displayList!.isEmpty
                ? const Center(
                    child: Text("No messages found"),
                  )
                : ListView.builder(
                    itemCount: displayList!.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final doctor = displayList![index];
                      final user = users.firstWhere(
                          (element) => element.userId == doctor.userId);
                      return ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatScreen(doctor),
                              ));
                        },
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                            doctor.image.toString(),
                          ),
                        ),
                        title: Text(
                          user.username.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: const Text(
                          "Tap to chat...",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: "Poppins",
                            color: Colors.black54,
                          ),
                        ),
                      );
                    },
                  )
          ],
        ),
      ),
    );
  }
}
