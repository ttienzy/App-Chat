import 'package:flutter/material.dart';

void showCreateGroupDialog(BuildContext context) {
  final TextEditingController _groupNameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<String> _mockUsers = [
    'user1@gmail.com',
    'user2@gmail.com',
    'user3@gmail.com',
    'user4@gmail.com',
  ];
  List<String> _selectedUsers = [];

  showDialog(
    context: context,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width * 0.8,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Tạo Nhóm Chat',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField(
                          controller: _groupNameController,
                          label: 'Tên nhóm',
                          maxLength: 50,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Vui lòng nhập tên nhóm';
                            }
                            if (value.trim().length < 3) {
                              return 'Tên nhóm phải có ít nhất 3 ký tự';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _descController,
                          label: 'Mô tả',
                          maxLength: 200,
                        ),
                        const SizedBox(height: 15),
                        _buildTextField(
                          controller: _emailController,
                          label: 'Thêm thành viên (Nhập Email)',
                          icon: Icons.search,
                          onChanged: (value) => setState(() {}),
                        ),
                        if (_emailController.text.isNotEmpty)
                          _buildUserSearchList(
                            _emailController.text,
                            _mockUsers,
                            _selectedUsers,
                            setState,
                          ),
                        const SizedBox(height: 15),
                        if (_selectedUsers.isNotEmpty)
                          _buildSelectedUsers(_selectedUsers, setState),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildActionButton('Hủy', Colors.grey.shade400, () {
                        Navigator.of(ctx).pop();
                      }),
                      _buildActionButton('Tạo Nhóm', Colors.blue, () {
                        if (_formKey.currentState!.validate()) {
                          // Gọi API hoặc xử lý dữ liệu
                          Navigator.of(ctx).pop();
                        }
                      }),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}

Widget _buildTextField({
  required TextEditingController controller,
  required String label,
  int? maxLength,
  IconData? icon,
  void Function(String)? onChanged,
  String? Function(String?)? validator,
}) {
  return TextFormField(
    controller: controller,
    maxLength: maxLength,
    onChanged: onChanged,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: icon != null ? Icon(icon) : null,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[100],
      counterText: '',
    ),
  );
}

Widget _buildUserSearchList(
  String query,
  List<String> users,
  List<String> selectedUsers,
  void Function(void Function()) setState,
) {
  final filteredUsers =
      users
          .where((user) => user.toLowerCase().contains(query.toLowerCase()))
          .toList();
  return Container(
    margin: const EdgeInsets.only(top: 8),
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey.shade300),
    ),
    constraints: const BoxConstraints(maxHeight: 150),
    child: ListView.builder(
      shrinkWrap: true,
      itemCount: filteredUsers.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredUsers[index]),
          trailing: IconButton(
            icon: const Icon(Icons.add_circle, color: Colors.blue),
            onPressed: () {
              if (!selectedUsers.contains(filteredUsers[index])) {
                setState(() {
                  selectedUsers.add(filteredUsers[index]);
                });
              }
            },
          ),
        );
      },
    ),
  );
}

Widget _buildSelectedUsers(
  List<String> selectedUsers,
  void Function(void Function()) setState,
) {
  return Wrap(
    spacing: 8,
    children:
        selectedUsers.map((user) {
          return Chip(
            label: Text(user),
            deleteIcon: const Icon(Icons.close),
            onDeleted: () {
              setState(() {
                selectedUsers.remove(user);
              });
            },
          );
        }).toList(),
  );
}

Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
  return ElevatedButton(
    onPressed: onPressed,
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    ),
  );
}
