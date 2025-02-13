import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hopeon_app/screens/parent_screens/ParentBottomNavBar.dart';
import 'package:hopeon_app/services/chat_service.dart';
class ParentChatScreen extends StatefulWidget {
  final String chatId;
  final String receiverName;
  final String senderId;
  final String receiverId;
  final String type;
  ParentChatScreen({required this.chatId, required this.receiverName, required this.senderId, required this.receiverId, required this.type});

  @override
  _ParentChatScreenState createState() => _ParentChatScreenState();
}

class _ParentChatScreenState extends State<ParentChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ChatService _chatService = ChatService();
  late final chat_id;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.type == "Student") {
      _initializeChatId();
    } else {
      chat_id = widget.chatId;
    }

    _chatService.markMessagesAsRead(widget.chatId, widget.senderId);
  }

  void _initializeChatId() async {
    setState(() {
      _isLoading = true;
    });
    String res = await _chatService.getChatId(widget.senderId);
    setState(() {
      chat_id = res;
      _isLoading = false;
    });
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    _chatService.sendMessage(
      chatId: chat_id,
      senderId: widget.senderId,
      receiverId: widget.receiverId,
      message: _controller.text,
    );

    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.receiverName,
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(37, 100, 255, 1.0),
        automaticallyImplyLeading: false,
        toolbarHeight: 100.0,

      ),
      body: _isLoading? const Center(child: CircularProgressIndicator(color: Colors.blue,),):Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream:  _chatService.getMessages(chat_id),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return Center(child: Text("No Chats yet"));
                if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

                return ListView.builder(
                  reverse: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var message = snapshot.data!.docs[index];
                    bool isMe = message['senderId'] == widget.senderId;
                    bool isFromDriver = message['senderId'] == widget.receiverId;

                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.blue[200]
                              : isFromDriver
                              ? Colors.green[200]  // Different color for group messages
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(message['text']),
                      ),
                    );

                  },
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
                    controller: _controller,
                    decoration: InputDecoration(labelText: "Enter message"),
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
      bottomNavigationBar: const ParentBottomNavBar(selectedScreen: 2),
    );
  }
}
