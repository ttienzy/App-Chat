import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:f2/message.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:f2/themeNotifier.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  final List<Message> _messages = [
    Message(text: "Hello, what can i help with ?", isUser: false),
  ];
  bool _isLoading = false;

  callGeminiModel() async {
    try {
      if (_controller.text.isNotEmpty) {
        // Thêm tin nhắn của người dùng
        _messages.add(Message(text: _controller.text, isUser: true));
        // Tạo tin nhắn loading
        final loadingMessage = Message(text: "...", isUser: false);
        setState(() {
          _messages.add(loadingMessage);
          _isLoading = true;
        });

        final model = GenerativeModel(
          model: 'gemini-2.0-flash',
          apiKey: dotenv.env['GOOGLE_API_KEY']!,
        );
        final prompt = _controller.text.trim();
        final content = [Content.text(prompt)];
        final response = await model.generateContent(content);

        setState(() {
          // Tìm vị trí tin nhắn loading và thay thế nó bằng phản hồi
          final loadingIndex = _messages.indexOf(loadingMessage);
          if (loadingIndex != -1) {
            _messages[loadingIndex] = Message(
              text: response.text ?? "Không có phản hồi",
              isUser: false,
            );
          } else {
            _messages.add(
              Message(
                text: response.text ?? "Không có phản hồi",
                isUser: false,
              ),
            );
          }
          _isLoading = false;
        });

        _controller.clear();
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        _isLoading = false;
        // Nếu xảy ra lỗi, cập nhật tin nhắn loading thành thông báo lỗi
        final loadingIndex = _messages.indexWhere((msg) => msg.text == "...");
        if (loadingIndex != -1) {
          _messages[loadingIndex] = Message(
            text: "Đã xảy ra lỗi",
            isUser: false,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 1,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/gpt-robot.png'),
                SizedBox(width: 10),
                Text(
                  'Gemini Gpt',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            GestureDetector(
              child:
                  (currentTheme == ThemeMode.dark)
                      ? Icon(
                        Icons.light_mode,
                        color: Theme.of(context).colorScheme.secondary,
                      )
                      : Icon(
                        Icons.dark_mode,
                        color: Theme.of(context).colorScheme.primary,
                      ),
              onTap: () {
                ref.read(themeProvider.notifier).toggleTheme();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return ListTile(
                  title: Align(
                    alignment:
                        message.isUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color:
                            message.isUser
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                        borderRadius:
                            message.isUser
                                ? BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )
                                : BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                      ),
                      child: Text(
                        message.text,
                        style:
                            message.isUser
                                ? Theme.of(context).textTheme.bodyMedium
                                : Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // user input
          Padding(
            padding: const EdgeInsets.only(
              bottom: 32,
              top: 16.0,
              left: 16.0,
              right: 16,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: Theme.of(context).textTheme.titleSmall,
                      decoration: InputDecoration(
                        hintText: 'Write your message',
                        hintStyle: Theme.of(
                          context,
                        ).textTheme.titleSmall!.copyWith(color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  _isLoading
                      ? Padding(
                        padding: EdgeInsets.all(8),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(),
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          child: Image.asset('assets/send.png'),
                          onTap: callGeminiModel,
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
}
