import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});

  // Reference for our collections
  final CollectionReference userCollection =
  FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
  FirebaseFirestore.instance.collection("groups");

  // Saving the user data
  Future<void> savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }

  // Getting user data
  Future<DocumentSnapshot> gettingUserData(String email) async {
    QuerySnapshot snapshot =
    await userCollection.where("email", isEqualTo: email).get();
    return snapshot.docs.first;
  }

  // Get user groups
  Stream<DocumentSnapshot> getUserGroups() {
    return userCollection.doc(uid).snapshots();
  }

  // Creating a group
  Future<void> createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference =
    await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });
    // Update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
  }

  // Getting the chats
  Stream<QuerySnapshot> getChats(String groupId) {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  // Get group admin
  Future<String> getGroupAdmin(String groupId) async {
    DocumentSnapshot documentSnapshot =
    await groupCollection.doc(groupId).get();
    return documentSnapshot['admin'];
  }

  // Get group members
  Stream<DocumentSnapshot> getGroupMembers(String groupId) {
    return groupCollection.doc(groupId).snapshots();
  }

  // Search by group name
  Future<QuerySnapshot> searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }

  // Check if user is joined to a group
  Future<bool> isUserJoined(String groupName, String groupId, String userName) async {
    DocumentSnapshot documentSnapshot = await userCollection.doc(uid).get();
    List<dynamic> groups = documentSnapshot['groups'];
    return groups.contains("${groupId}_$groupName");
  }

  // Toggle group join/exit
  Future<void> toggleGroupJoin(String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = documentSnapshot['groups'];

    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  // Send message
  Future<void> sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    await groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    await groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }

  // Delete message
  Future<void> deleteMessage(String groupId, String messageId) async {
    await groupCollection
        .doc(groupId)
        .collection("messages")
        .doc(messageId)
        .delete();
  }
}
