import 'package:f1/models/member.dart';
import 'package:f1/services/project_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void showJoinProjectDialog(BuildContext context) {
  final TextEditingController roomIdController = TextEditingController();
  final _user = FirebaseAuth.instance.currentUser;

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Tham gia dự án'),
        content: TextField(
          controller: roomIdController,
          decoration: const InputDecoration(
            labelText: 'ID phòng',
            hintText: 'Nhập ID phòng để tham gia dự án',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              final roomId = roomIdController.text.trim();
              if (roomId.isNotEmpty) {
                final results = await getProjectByIdServices(roomId);
                if (results['status'] == false) {
                  const SnackBar(content: Text('ID phòng không đúng'));
                  return;
                }
                List<String> members = List<String>.from(results['members']);
                members.add(
                  Member(roleIn: 'member', userId: _user!.uid).toString(),
                );
                var result = await addToMemberServices(roomId, members);
                if (!result) {
                  const SnackBar(
                    content: Text('Có lỗi xảy ra khi thêm thành viên mới'),
                  );
                  return;
                }
                Navigator.of(context).pop(); // Đóng dialog sau khi xử lý
              } else {
                // Nếu cần hiển thị cảnh báo người dùng nhập thông tin
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vui lòng nhập ID phòng')),
                );
              }
            },
            child: const Text('Tham gia'),
          ),
        ],
      );
    },
  );
}
