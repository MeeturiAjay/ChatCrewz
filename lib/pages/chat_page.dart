import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../service/database_service.dart';
import '../shared/app_colors.dart';
import '../widgets/message_tile.dart';
import '../widgets/widgets.dart';
import 'group_info.dart';
import 'introscreens/splashscreen.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messageController = TextEditingController();
  String admin = "";
  final ScrollController _scrollController = ScrollController();
  List<String> selectedMessageIds = [];

  @override
  void initState() {
    super.initState();
    getChatandAdmin();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void getChatandAdmin() async {
    // Fetch chats
    var val = await DatabaseService().getChats(widget.groupId);
    setState(() {
      chats = val;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) => scrollToBottom());

    // Fetch group admin
    var valAdmin = await DatabaseService().getGroupAdmin(widget.groupId);
    setState(() {
      admin = valAdmin;
    });
  }

  void scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.linearToEaseOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
        title: Text(
          widget.groupName,
          style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.bgcolor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfo(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                ),
              );
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: chatMessages(),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            color: Colors.blue,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.image),
                          onPressed: () {
                            getImageFromGallery();
                          },
                        ),
                        Expanded(
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: messageController,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                              hintText: "Message ChatCrewZ",
                              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    sendMessage();
                  },
                  icon: Icon(Icons.send, color: Colors.white, size: 30,),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: selectedMessageIds.isEmpty
          ? null
          : FloatingActionButton.extended(
        onPressed: () {
          deleteSelectedMessages();
        },
        label: Text('Delete (${selectedMessageIds.length})'),
        icon: Icon(Icons.delete),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: SplashScreen());
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No messages yet"));
        } else {
          WidgetsBinding.instance!.addPostFrameCallback((_) => scrollToBottom());

          // Group messages by date
          final messagesByDate = _groupMessagesByDate(snapshot.data!.docs);

          return ListView.builder(
            controller: _scrollController,
            itemCount: messagesByDate.length,
            itemBuilder: (context, index) {
              final date = messagesByDate.keys.elementAt(index);
              final messages = messagesByDate[date]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child: Text(
                      _formatDate(date),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ...messages.map((message) {
                    final messageId = message.id;
                    final timestamp = DateTime.fromMillisecondsSinceEpoch(message['time']);
                    final isSelected = selectedMessageIds.contains(messageId);

                    return MessageTile(
                      message: message['message'],
                      sender: message['sender'],
                      sentByMe: widget.userName == message['sender'],
                      timestamp: timestamp,
                      isSelected: isSelected,
                      onLongPress: () {
                        toggleMessageSelection(messageId);
                      },
                      onDelete: () {
                        // Implement delete functionality here
                        DatabaseService().deleteMessage(widget.groupId, messageId);
                      },
                    );
                  }).toList(),
                ],
              );
            },
          );
        }
      },
    );
  }

  Map<DateTime, List<QueryDocumentSnapshot>> _groupMessagesByDate(List<QueryDocumentSnapshot> docs) {
    final messagesByDate = <DateTime, List<QueryDocumentSnapshot>>{};

    for (var doc in docs) {
      final timestamp = DateTime.fromMillisecondsSinceEpoch(doc['time']);
      final date = DateTime(timestamp.year, timestamp.month, timestamp.day);

      if (!messagesByDate.containsKey(date)) {
        messagesByDate[date] = [];
      }

      messagesByDate[date]!.add(doc);
    }

    return messagesByDate;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(Duration(days: 1));

    if (date == today) {
      return "Today";
    } else if (date == yesterday) {
      return "Yesterday";
    } else {
      return "${date.day}/${date.month}/${date.year}";
    }
  }

  void sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().millisecondsSinceEpoch,
        "type": "text", // Add a type field to distinguish text messages
      };

      DatabaseService().sendMessage(widget.groupId, chatMessageMap);

      messageController.clear();
    }
  }

  Future<void> getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      // Read the file and convert it to bytes
      File imageFile = File(pickedFile.path);
      List<int> imageBytes = await imageFile.readAsBytes();

      sendMessageImage(imageBytes); // Send the image bytes as a message
    } else {
      // User canceled the picker
    }
  }

  void sendMessageImage(List<int> imageBytes) {
    // Assuming 'message' field in Firestore can store bytes directly
    Map<String, dynamic> chatMessageMap = {
      "message": imageBytes,
      "sender": widget.userName,
      "time": DateTime.now().millisecondsSinceEpoch,
      "type": "image", // Add a type field to distinguish image messages
    };

    DatabaseService().sendMessage(widget.groupId, chatMessageMap);
  }

  void toggleMessageSelection(String messageId) {
    setState(() {
      if (selectedMessageIds.contains(messageId)) {
        selectedMessageIds.remove(messageId);
      } else {
        selectedMessageIds.add(messageId);
      }
    });
  }

  void deleteSelectedMessages() {
    // Create a batch to delete all selected messages
    WriteBatch batch = FirebaseFirestore.instance.batch();

    selectedMessageIds.forEach((messageId) {
      // Reference to the document of the message to be deleted
      DocumentReference messageRef = FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .collection('messages')
          .doc(messageId);
      batch.delete(messageRef);
    });

    // Commit the batched delete operation
    batch.commit().then((_) {
      // Clear the selected message IDs list after successful deletion
      setState(() {
        selectedMessageIds.clear();
      });
    }).catchError((error) {
      // Handle any errors that occur during deletion
      print("Error deleting messages: $error");
      // Optionally, show a snackbar or alert to the user
    });
  }
}
