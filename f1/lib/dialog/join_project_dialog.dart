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
      return Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header với gradient
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5E35B1), Color(0xFF7E57C2)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.group_add_rounded,
                        color: Colors.white.withOpacity(0.9),
                        size: 28,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Tham gia dự án',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 24,
                ),
                child: Column(
                  children: [
                    // Icon minh họa
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF5E35B1).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: const Icon(
                        Icons.vpn_key_rounded,
                        color: Color(0xFF5E35B1),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Text giải thích
                    Text(
                      'Nhập ID phòng dự án để tham gia vào nhóm làm việc',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                    const SizedBox(height: 20),

                    // Trường nhập ID
                    TextField(
                      controller: roomIdController,
                      decoration: InputDecoration(
                        labelText: 'ID phòng',
                        hintText: 'Nhập ID phòng để tham gia dự án',
                        prefixIcon: const Icon(
                          Icons.numbers_rounded,
                          color: Color(0xFF5E35B1),
                        ),
                        floatingLabelStyle: const TextStyle(
                          color: Color(0xFF5E35B1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xFF5E35B1),
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),

              // Divider
              Divider(height: 1, color: Colors.grey[200]),

              // Buttons
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Hủy button
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Colors.grey[300]!),
                          ),
                        ),
                        child: Text(
                          'Hủy',
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Tham gia button
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final roomId = roomIdController.text.trim();
                          if (roomId.isNotEmpty) {
                            final results = await getProjectByIdServices(
                              roomId,
                            );
                            if (results['status'] == false) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('ID phòng không đúng'),
                                ),
                              );
                              return;
                            }
                            List<String> members = List<String>.from(
                              results['members'],
                            );
                            members.add(
                              Member(
                                roleIn: 'member',
                                userId: _user!.uid,
                              ).toString(),
                            );
                            var result = await addToMemberServices(
                              roomId,
                              members,
                            );
                            if (!result) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Có lỗi xảy ra khi thêm thành viên mới',
                                  ),
                                ),
                              );
                              return;
                            }
                            Navigator.of(context).pop();
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Vui lòng nhập ID phòng'),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E35B1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.login_rounded,
                              size: 18,
                              color: Color.fromARGB(179, 146, 140, 140),
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Tham gia',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
