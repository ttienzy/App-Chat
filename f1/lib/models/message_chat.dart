import 'dart:io';

class MessageChat {
  final String? text;
  final File? image;
  final bool isUser;

  MessageChat({this.text, this.image, required this.isUser});
}
