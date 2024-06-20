import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasechatapplatest/shared/app_colors.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import '../pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupId;
  final String groupName;
  const GroupTile({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  String? adminName; // Nullable variable to store admin's name

  @override
  void initState() {
    super.initState();
    fetchAdminName(); // Fetch admin's name when widget initializes
  }

  void fetchAdminName() async {
    // Retrieve admin's name from Firestore based on groupId
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('groups')
          .doc(widget.groupId)
          .get();

      if (doc.exists) {
        setState(() {
          adminName = doc['admin']; // Assuming 'admin' field exists in your document
        });
      }
    } catch (e) {
      print("Failed to get admin's name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to ChatPage on tap
        nextScreen(
          context,
          ChatPage(
            groupId: widget.groupId,
            groupName: widget.groupName,
            userName: widget.userName,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: AppColors.bgcolor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          title: Text(
            widget.groupName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: adminName != null
              ? Text(
            "Admin: ${getName(adminName!)}",
            style: const TextStyle(fontSize: 13),
          )
              : SizedBox.shrink(), // Handle case where adminName is null
        ),
      ),
    );
  }

  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }
}
