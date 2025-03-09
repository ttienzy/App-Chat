import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang cá nhân')),
      body: const Center(child: Text('Nội dung trang cá nhân')),
    );
  }
}
