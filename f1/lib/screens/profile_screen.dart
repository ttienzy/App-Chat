import 'package:f1/auth/theme_notifier.dart';
import 'package:f1/shared/convert_timestamp_to_date.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({super.key});
  final _user = FirebaseAuth.instance.currentUser;
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final isDarkMode = themeNotifier.isDarkMode;
    final theme = Theme.of(context);
    //Timestamp timestamp = Timestamp(widget._user!.);

    String _currentPosition = 'Flutter Developer';
    String _currentAddress = 'Hà Nội, Việt Nam';
    final String joinDate = formatAuthTime(
      widget._user!.metadata.creationTime.toString(),
    ); // Giả sử ngày tham gia không đổi
    void showUpdateInfoDialog(BuildContext context) {
      final positionController = TextEditingController(text: _currentPosition);
      final addressController = TextEditingController(text: _currentAddress);

      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: const Text('Cập nhật thông tin'),
            content: SingleChildScrollView(
              // Dùng SingleChildScrollView nếu nội dung có thể dài
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: positionController,
                    decoration: const InputDecoration(labelText: 'Chức vụ mới'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(labelText: 'Địa chỉ mới'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Hủy'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Lưu'),
                onPressed: () {
                  print('Trước khi cập nhật:');
                  print('positionController.text: ${positionController.text}');
                  print('_currentPosition (state): $_currentPosition');
                  print('addressController.text: ${addressController.text}');
                  print('_currentAddress (state): $_currentAddress');
                  // ----- DEBUGGING END -----

                  // Đảm bảo setState được gọi và gán giá trị đúng
                  setState(() {
                    _currentPosition = positionController.text;
                    _currentAddress = addressController.text;

                    // ----- DEBUGGING START -----
                    print('Bên trong setState:');
                    print('_currentPosition (state): $_currentPosition');
                    print('_currentAddress (state): $_currentAddress');
                    // ----- DEBUGGING END -----
                  });

                  // ----- DEBUGGING START -----
                  print('Sau khi setState được gọi:');
                  print('_currentPosition (state): $_currentPosition');
                  print('_currentAddress (state): $_currentAddress');
                  // ----- DEBUGGING END -----

                  Navigator.of(dialogContext).pop();
                },
              ),
            ],
          );
        },
      );
    }

    Widget buildUserInfoSection(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 2, // Thêm chút đổ bóng cho đẹp
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Căn lề trái cho đẹp hơn
              children: [
                _buildInfoRow(
                  Icons.work,
                  'Chức vụ',
                  _currentPosition,
                ), // Sử dụng state
                const Divider(),
                _buildInfoRow(
                  Icons.location_on,
                  'Địa chỉ',
                  _currentAddress,
                ), // Sử dụng state
                const Divider(),
                _buildInfoRow(Icons.calendar_today, 'Tham gia', joinDate),
                const SizedBox(height: 20), // Khoảng cách trước nút
                // 3. Thêm nút "Cập nhật"
                Center(
                  // Căn giữa nút
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.edit),
                    label: const Text('Cập nhật thông tin'),
                    onPressed: () {
                      showUpdateInfoDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      //backgroundColor: isDarkMode ? Colors.grey[900] : Colors.grey[100],
      appBar: AppBar(
        title: Text('Trang cá nhân', style: theme.textTheme.headlineLarge),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: themeNotifier.toggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(theme),
            buildUserInfoSection(context),
            _buildSettingsSection(context, themeNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme) {
    return Container(
      height: 200,
      width: double.maxFinite,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:
              theme.brightness == Brightness.dark
                  ? [Colors.blueGrey[500]!, Colors.blueGrey[900]!]
                  : [Colors.blue[200]!, Colors.blue[400]!],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              widget._user!.photoURL ?? 'https://i.pravatar.cc/150?img=3',
            ),
            backgroundColor: theme.scaffoldBackgroundColor,
          ),
          const SizedBox(height: 16),
          Text(
            widget._user!.displayName ?? 'Nguyễn Văn A',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color:
                  theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            widget._user!.email ?? 'nguyenvana@example.com',
            style: TextStyle(
              color:
                  theme.brightness == Brightness.dark
                      ? Colors.grey[300]
                      : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(221, 7, 192, 233),
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Color.fromARGB(255, 81, 82, 79),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(
    BuildContext context,
    ThemeNotifier themeNotifier,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          children: [
            SwitchListTile(
              title: const Text('Chế độ ban đêm'),
              secondary: const Icon(Icons.dark_mode),
              value: themeNotifier.isDarkMode,
              onChanged: (value) => themeNotifier.toggleTheme(),
            ),
            const Divider(height: 0),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Đăng xuất'),
              onTap: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
          title: const Text('Xác nhận đăng xuất'),
          content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'Đăng xuất',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        ),
  );
}
