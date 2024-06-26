import 'dart:ui';
import 'package:firebasechatapplatest/shared/app_colors.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentByMe;
  final DateTime timestamp;

  const MessageTile({
    Key? key,
    required this.message,
    required this.sender,
    required this.sentByMe,
    required this.timestamp,
  }) : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 4,
        bottom: 4,
        left: widget.sentByMe ? 0 : 24,
        right: widget.sentByMe ? 24 : 0,
      ),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentByMe
            ? const EdgeInsets.only(left: 30)
            : const EdgeInsets.only(right: 30),
        padding: const EdgeInsets.only(
          top: 10,
          bottom: 10,
          left: 20,
          right: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: widget.sentByMe ? Radius.circular(20) : Radius.zero,
            bottomRight: widget.sentByMe ? Radius.zero : Radius.circular(20),
          ),
          color: widget.sentByMe ? AppColors.bgcolor : Colors.grey[700],
        ),
        child: Column(
          crossAxisAlignment:
          widget.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              widget.sentByMe ? "YOU" : widget.sender.toUpperCase(),
              textAlign: widget.sentByMe ? TextAlign.end : TextAlign.start,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.message,
              textAlign: widget.sentByMe ? TextAlign.end : TextAlign.start,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _formatTimestamp(widget.timestamp),
              textAlign: widget.sentByMe ? TextAlign.end : TextAlign.start,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
          ],
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