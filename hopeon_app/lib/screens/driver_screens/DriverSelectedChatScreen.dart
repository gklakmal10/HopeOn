import 'package:flutter/material.dart';
import 'package:hopeon_app/screens/driver_screens/DriverBottomNavBar.dart';
import 'package:hopeon_app/screens/driver_screens/DriverChatScreen.dart';

class DriverSelectedChatScreen extends StatefulWidget {
  const DriverSelectedChatScreen({super.key});

  @override
  State<DriverSelectedChatScreen> createState() =>
      _DriverSelectedChatScreenState();
}

class _DriverSelectedChatScreenState extends State<DriverSelectedChatScreen> {
  final List<Map<String, dynamic>> messages = [
    {
      'text': 'Hi, good morning. Is the bus running on time today?',
      'isMe': true
    },
    {
      'text':
          'Good morning! Yes, the bus is on schedule and will reach your stop at 7:45 AM.',
      'isMe': false
    },
    {
      'text':
          'Thank you for confirming. Is there any delay on the route today?',
      'isMe': true
    },
    {
      'text': 'No delays so far, but I’ll notify you if anything changes.',
      'isMe': false
    },
    {
      'text':
          'Great! Also, could you please remind my child to take their lunchbox from the bag?',
      'isMe': true
    },
    {'text': 'Sure, I’ll inform them as soon as they board.', 'isMe': false},
    {'text': 'Thanks a lot for your help and Kindness!', 'isMe': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(left: 0),
          child: Text(
            "Chats",
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
          ),
        ),
        backgroundColor: Color.fromRGBO(37, 100, 255, 1.0),
        leading: IconButton(
          onPressed: () => {
            // Navigator.pushReplacement(
            //   context,
            //   //MaterialPageRoute(builder: (context) => DriverChatScreen()),
            // )
          },
          icon: Icon(Icons.arrow_back_outlined, color: Colors.white,),
        ),
        toolbarHeight: 100.0, // Increases the height of the AppBar
      ),
      body: Column(
        children: [
          // Chat Messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                bool isMe = message['isMe'];

                return Padding(
                  padding: message['isMe']
                      ? const EdgeInsets.fromLTRB(70, 0, 0, 10)
                      : const EdgeInsets.fromLTRB(0, 0, 70, 10),
                  child: Row(
                    mainAxisAlignment:
                        isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                    children: [
                      if (!isMe) // Driver's Avatar (Left)
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/2922/2922510.png"), // Replace with your driver image
                        ),

                      // Message Bubble
                      Flexible(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue[200] : Colors.grey[300],
                            borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(10),
                                topRight: const Radius.circular(10),
                                bottomLeft: isMe
                                    ? const Radius.circular(10)
                                    : Radius.zero,
                                bottomRight:
                                    isMe ? Radius.zero : Radius.circular(10)),
                          ),
                          child: Text(
                            message['text'],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ),

                      if (isMe) // Parent's Avatar (Right)
                        const CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(
                              "https://cdn-icons-png.flaticon.com/512/2922/2922561.png"), // Replace with your parent image
                        ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Message Input
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                const CircleAvatar(
                  backgroundColor: Colors.blue,
                  child: Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
