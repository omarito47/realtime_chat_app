import 'package:chat_app/global/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  // get  instance of firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection('Users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final user = doc.data();
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiveID, String message) async {
    //get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // create a new message
    Message newMessage = Message(
        senderID: currentUserID,
        senderEmail: currentUserEmail,
        receiverID: receiveID,
        message: message,
        timestamp: timestamp);

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiveID];
    ids.sort(); // sort the ids (this ensure the chatroomID is the same for any 2 people)
    // example user1 id=1 and user2 id=2 when i login with user1 to chat with user2
    // the chatroomID will be 1-2
    // and when i log in with user2 the chatroomId will be 1-2
    // but without sort function the chatroom it will be 2-1 so it's not the same chatroom for the users
    String chatRoomID = ids.join('-');

    // add message to firestore
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .add(newMessage.toMap());
  }

  // get messages
  Stream<QuerySnapshot>getMessage(String userID,otherUserID){
    // construct a chatroom ID for the two users
    List<String> ids =[userID,otherUserID];
    ids.sort();
    String chatRoomID = ids.join('-');

    return _firestore
      .collection('chat_rooms')
      .doc(chatRoomID)
      .collection('messages')
      .orderBy('timestamp',descending: false)
      .snapshots();
  }
  // Function to get the chatRoomID
String getChannelId( String receiveID) {
  
  List<String> ids = [ _auth.currentUser!.uid, receiveID];
  ids.sort();
  String chatRoomID = ids.join('-');
  return chatRoomID;
}

}
