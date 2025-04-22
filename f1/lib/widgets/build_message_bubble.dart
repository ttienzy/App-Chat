import 'package:f1/models/groups.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildMessageBubble(Message message, String userId, bool isDarkMode) {
  var userInfo = message.user;
  var isMe = (userInfo?.uid == userId);

  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment:
          CrossAxisAlignment.end, // Align avatars with bottom of bubbles
      children: [
        if (!isMe)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child:
                userInfo?.photoUrl != null
                    ? CircleAvatar(
                      radius: 16,
                      backgroundImage: NetworkImage(userInfo!.photoUrl!),
                    )
                    : CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.deepPurple[300],
                      child: Text(
                        (userInfo?.name?.isNotEmpty == true)
                            ? userInfo!.name!.substring(0, 1).toUpperCase()
                            : message.id.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Color.fromARGB(94, 24, 18, 194),
                          fontSize: 14,
                        ),
                      ),
                    ),
          ),
        Flexible(
          child: Container(
            margin: EdgeInsets.only(left: isMe ? 60 : 0, right: isMe ? 0 : 60),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color:
                  isMe && isDarkMode
                      ? const Color.fromARGB(255, 79, 81, 82)
                      : const Color.fromARGB(255, 234, 209, 209),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20),
                bottomLeft: Radius.circular(isMe ? 20 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              //isMe ? CrossAxisAlignment.end : CrossAxisAlignment.end,
              children: [
                Text(
                  message.content,
                  style: TextStyle(
                    color:
                        isMe && isDarkMode
                            ? Colors.white
                            : const Color.fromARGB(221, 18, 1, 1),
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  message.createdAt,
                  style: TextStyle(
                    color: isMe ? Colors.white70 : Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
