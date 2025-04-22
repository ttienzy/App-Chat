import 'package:f1/auth/theme_notifier.dart';
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
            _buildUserInfoSection(context),
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

  Widget _buildUserInfoSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildInfoRow(Icons.work, 'Chức vụ', 'Flutter Developer'),
              const Divider(),
              _buildInfoRow(Icons.location_on, 'Địa chỉ', 'Hà Nội, Việt Nam'),
              const Divider(),
              _buildInfoRow(Icons.calendar_today, 'Tham gia', '01/01/2023'),
            ],
          ),
        ),
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
                onPressed: () {
                  Navigator.pop(context);
                  // Thêm logic đăng xuất ở đây
                  Navigator.pop(context); // Quay lại màn hình trước
                },
                child: const Text(
                  'Đăng xuất',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
