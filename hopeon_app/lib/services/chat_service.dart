import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch all chat rooms
  Stream<QuerySnapshot> getChatRooms(String driverId) {
    return _firestore.collection('chats')
        .where('driverId', isEqualTo: driverId)
        .snapshots();
  }

  /// Fetch messages for a chat
  Stream<QuerySnapshot> getMessages(String chatId) {
    return _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<String> getChatId(String studentId)async{
    QuerySnapshot chat = await _firestore
        .collection('chats')
        .where('studentId', isEqualTo: studentId)
        .get();

    return chat.docs.first['chatId'];
  }



  /// Mark messages as read
  Future<void> markMessagesAsRead(String chatId, String currentUserId) async {
    QuerySnapshot unreadMessages = await _firestore
        .collection('messages')
        .where('chatId', isEqualTo: chatId)
        .where('isRead', isEqualTo: false)
        .where('receiverId', isEqualTo: currentUserId)
        .get();

    for (var doc in unreadMessages.docs) {
      await doc.reference.update({'isRead': true});
    }

    await _firestore.collection('chats').doc(chatId).update({
      'unreadCount': 0,
    });
  }

  /// Send a new message
  Future<void> sendMessage({
    required String chatId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    await _firestore.collection('messages').add({
      'chatId': chatId,
      'text': message,
      'senderId': senderId,
      'receiverId': receiverId,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
    });

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': message,
      'lastTime': FieldValue.serverTimestamp(),
      'unreadCount': FieldValue.increment(1),
    });
  }

  Future<void> createDriverChats( String driverId, List<dynamic> students) async {
    for(int i=0; i< students.length; i++){
      Map<String, dynamic> student = students[i];
      QuerySnapshot driverSendMessage = await _firestore
          .collection('chats')
          .where('driverId', isEqualTo: driverId)
          .where('studentId', isEqualTo: student['id'].toString())
          .get();

      if (driverSendMessage.size <= 0) {
        final chatsDoc =
        FirebaseFirestore.instance.collection('chats').doc();

        await chatsDoc.set({
          'chatId': chatsDoc.id,
          'driverId':driverId,
          'studentId':student['id'].toString(),
          'lastMessage': null,
          'lastTime': FieldValue.serverTimestamp(),
          'unreadCount': 0,
        });
      }
    }

  }

  Future<void> sendGroupMessage({
    required String driverId,
    required List<dynamic> students,
    required String message,
  }) async {

    for (var student in students) {
      String studentId = student['id'].toString();

      // Get chat ID for each student
      QuerySnapshot chatSnapshot = await _firestore
          .collection('chats')
          .where('driverId', isEqualTo: driverId)
          .where('studentId', isEqualTo: studentId)
          .get();

      if (chatSnapshot.docs.isNotEmpty) {
        String chatId = chatSnapshot.docs.first.id;

        // Send the message
        await _firestore.collection('messages').add({
          'chatId': chatId,
          'text': message,
          'senderId': driverId,
          'receiverId': studentId,
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': true,
        });

        // Update last message in chat
        await _firestore.collection('chats').doc(chatId).update({
          'lastMessage': message,
          'lastTime': FieldValue.serverTimestamp(),
          'unreadCount':0
        });
      }
    }
  }


}
