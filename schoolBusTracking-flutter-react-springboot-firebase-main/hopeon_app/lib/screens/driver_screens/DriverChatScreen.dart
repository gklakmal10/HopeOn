import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hopeon_app/screens/driver_screens/DriverBottomNavBar.dart';
import 'package:hopeon_app/screens/parent_screens/ParentChatScreen.dart';
import 'package:hopeon_app/services/chat_service.dart';
import 'package:hopeon_app/services/schedule_service.dart';

class DriverChatScreen extends StatefulWidget {
  final String vehicleId;
  final String driverId;

  const DriverChatScreen(
      {super.key, required this.vehicleId, required this.driverId});

  @override
  State<DriverChatScreen> createState() => _DriverChatScreenState();
}

class _DriverChatScreenState extends State<DriverChatScreen> {
  final ChatService _chatService = ChatService();
  List<dynamic> students = [];

  final String currentUserId = "2";
  final ScheduleService _scheduleService = ScheduleService();
  bool _isLoading = false;

  void _loadAttendance() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> res = await _scheduleService.getAttendance(
        widget.vehicleId,
        DateTime.now().toIso8601String().split("T")[0],
        "TO_SCHOOL");
    if (res['success']) {
      await _chatService
          .createDriverChats(currentUserId, res['body'])
          .then((val) {
        setState(() {
          students = res['body'];
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    _loadAttendance();
    super.initState();
  }

  void _showGroupChatDialog() {
    TextEditingController _messageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Send Group Message"),
          content: TextField(
            controller: _messageController,
            decoration: const InputDecoration(hintText: "Enter your message"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                if (_messageController.text.trim().isNotEmpty) {
                  await _chatService.sendGroupMessage(
                    driverId: widget.driverId,
                    students: students,
                    message: _messageController.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text("Send"),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(37, 100, 255, 1.0),
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,
        actions: [
          IconButton(
            icon: const Icon(Icons.groups, color: Colors.white),
            onPressed: () {
              _showGroupChatDialog();
            },
          ),
        ],

      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Colors.blue,
              ),
            )
          : StreamBuilder(
              stream: _chatService.getChatRooms(widget.driverId),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                var chatRooms = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: chatRooms.length,
                  itemBuilder: (context, index) {
                    var chat = chatRooms[index];
                    var lastMessage = chat['lastMessage'] ?? 'No messages yet';
                    var lastTime = chat['lastTime'] != null
                        ? (chat['lastTime'] as Timestamp).toDate()
                        : DateTime.now();
                    var unreadCount = chat['unreadCount'] ?? 0;
                    var chatId = chat.id;
                    var receiverName = students.firstWhere((st) =>
                            st["id"].toString() ==
                            chat['studentId'])["fullName"] ??
                        "";
                    var receiverImage = students.firstWhere((st) =>
                            st["id"].toString() ==
                            chat['studentId'])["imageUrl"] ??
                        "";

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: receiverImage.isNotEmpty
                            ? NetworkImage(receiverImage)
                            : const AssetImage("assets/default_profile.png")
                                as ImageProvider,
                      ),
                      title: Text(receiverName),
                      subtitle: Text(lastMessage,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${lastTime.hour}:${lastTime.minute}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          if (unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "$unreadCount",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                      onTap: () async {
                        await _chatService.markMessagesAsRead(
                            chatId, currentUserId);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ParentChatScreen(
                              chatId: chatId,
                              receiverName: receiverName,
                              senderId: widget.driverId,
                              receiverId: chat['studentId'],
                              type: 'Driver',
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: const DriverBottomNavBar(selectedScreen: 2),
    );
  }
}
