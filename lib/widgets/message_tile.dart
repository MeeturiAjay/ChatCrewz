import 'package:flutter/material.dart';
import 'package:firebasechatapplatest/shared/app_colors.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final DateTime timestamp;
  final bool isSelected;
  final VoidCallback onLongPress;
  final VoidCallback onDelete;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.timestamp,
    required this.isSelected,
    required this.onLongPress,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(timestamp.toString()), // Use a unique key for each message
      direction: sentByMe ? DismissDirection.endToStart : DismissDirection.startToEnd,
      background: Container(
        color: Colors.red,
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => onDelete(),
      child: Container(
        padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: sentByMe ? 0 : 24,
          right: sentByMe ? 24 : 0,
        ),
        alignment: sentByMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: sentByMe ? const EdgeInsets.only(left: 30) : const EdgeInsets.only(right: 30),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: sentByMe ? Radius.circular(20) : Radius.zero,
              bottomRight: sentByMe ? Radius.zero : Radius.circular(20),
            ),
            color: sentByMe ? AppColors.bgcolor : Colors.grey[700],
          ),
          child: Column(
            crossAxisAlignment: sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                sentByMe ? "YOU" : sender.toUpperCase(),
                textAlign: sentByMe ? TextAlign.end : TextAlign.start,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                textAlign: sentByMe ? TextAlign.end : TextAlign.start,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _formatTimestamp(timestamp),
                textAlign: sentByMe ? TextAlign.end : TextAlign.start,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final hour = timestamp.hour % 12 == 0 ? 12 : timestamp.hour % 12;
    final minute = timestamp.minute.toString().padLeft(2, '0');
    final period = timestamp.hour >= 12 ? 'PM' : 'AM';
    return "$hour:$minute $period";
  }
}
