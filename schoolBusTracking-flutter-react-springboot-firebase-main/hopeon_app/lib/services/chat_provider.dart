// import 'package:flutter/cupertino.dart';
// import 'package:hopeon_app/models/message_model.dart';
// import 'package:hopeon_app/services/chat_service.dart';
//
// class ChatProvider with ChangeNotifier {
//   final ChatService _chatService = ChatService();
//   List<Message> _messages = [];
//   List<Message> _globalMessages = [];
//
//   List<Message> get messages => _messages;
//   List<Message> get globalMessages => _globalMessages;
//
//   Future<void> loadMessages(int senderId, int receiverId) async {
//     _messages = await _chatService.getMessages(senderId, receiverId);
//     notifyListeners();
//   }
//
//   Future<void> loadGlobalMessages() async {
//     _globalMessages = await _chatService.getGlobalMessages();
//     notifyListeners();
//   }
//
//   Future<void> sendMessage(Message message) async {
//     await _chatService.sendMessage(message);
//     if (message.isGlobalMessage) {
//       _globalMessages.insert(0, message);
//     } else {
//       _messages.insert(0, message);
//     }
//     notifyListeners();
//   }
// }