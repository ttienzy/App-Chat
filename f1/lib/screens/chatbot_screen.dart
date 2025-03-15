import 'dart:io';

import 'package:f1/models/message_chat.dart';
import 'package:f1/screens/loading_indicator.dart';
import 'package:f1/widgets/chatbot_message_bubble.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:image_picker/image_picker.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({super.key});

  @override
  State<ChatbotScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatbotScreen> {
  final List<MessageChat> _messages = [];
  final TextEditingController _textController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  final gemini = Gemini.instance;

  // 1) Thêm biến này để lưu ảnh người dùng vừa chọn
  File? _selectedImage;

  void _sendTextMessage(String text) async {
    if (text.isEmpty) return;

    // Kiểm tra nếu đang có ảnh thì gửi ảnh kèm text
    if (_selectedImage != null) {
      _sendImageMessage(_selectedImage!, text);
      _selectedImage = null; // reset ảnh sau khi gửi
      return;
    }

    // Nếu không có ảnh, chỉ gửi text
    setState(() {
      _messages.add(MessageChat(text: text, isUser: true));
      _isLoading = true;
    });

    try {
      final response = await gemini.chat([
        Content(role: 'user', parts: [Part.text(text)]),
      ]);
      setState(() {
        _messages.add(
          MessageChat(text: response?.output ?? "No response", isUser: false),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(MessageChat(text: "Error: $e", isUser: false));
        _isLoading = false;
      });
    }

    _textController.clear();
  }

  void _sendImageMessage(File image, [String? text]) async {
    setState(() {
      _messages.add(MessageChat(image: image, text: text, isUser: true));
      _isLoading = true;
    });
    try {
      final response = await gemini.chat([
        Content(
          role: 'user',
          parts: [
            Part.text(text ?? 'Mô tả bức ảnh này'),
            Part.uint8List(image.readAsBytesSync()),
          ],
        ),
      ]);
      setState(() {
        _messages.add(
          MessageChat(text: response?.output ?? "No response", isUser: false),
        );
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _messages.add(MessageChat(text: "Error: $e", isUser: false));
        _isLoading = false;
      });
    }
    _textController.clear();
  }

  // 2) Chỉ chọn ảnh và lưu vào _selectedImage, không hiển thị dialog nhập text
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  // Hàm chọn file
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _messages.add(
          MessageChat(
            text: "File attached: ${result.files.single.name}",
            isUser: true,
          ),
        );
      });
      // Thêm logic gửi file đến Gemini nếu cần
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Gemini Chat')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  reverse: true,
                  itemCount: _messages.length + (_isLoading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length) {
                      return const LoadingIndicator();
                    }
                    final message = _messages[_messages.length - index - 1];
                    return MessageBubble(message: message);
                  },
                ),
              ),
              // Thanh nhập liệu
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.attach_file),
                      onPressed: _pickImage,
                    ),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: 'Write something...',
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: _sendTextMessage,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.image),
                      onPressed: _pickImage,
                    ),
                    IconButton(
                      icon: const Icon(Icons.send),
                      onPressed: () => _sendTextMessage(_textController.text),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // 3) Nếu có ảnh đang chọn thì hiển thị “float” chứa ảnh ở góc
          if (_selectedImage != null)
            Positioned(
              right: 16,
              bottom: 80, // nằm trên thanh chat 1 chút
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  // Khung ảnh
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black26),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Nút xoá ảnh
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white70,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
