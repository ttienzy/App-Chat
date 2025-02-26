import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:f1/services/user_services.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _userService = FirestoreService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // serverClientId:
    //     '755419252191-6mkbbujpg430bmalpe4mpeqgof4vjodu.apps.googleusercontent.com',
  );

  Future<void> _signInWithEmailPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Welcome ${userCredential.user?.email}!")),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Đã xảy ra lỗi';
      if (e.code == 'invalid-email')
        message = 'Email không hợp lệ';
      else if (e.code == 'user-disabled')
        message = 'Tài khoản bị vô hiệu hóa';
      else if (e.code == 'user-not-found')
        message = 'Không tìm thấy người dùng';
      else if (e.code == 'wrong-password')
        message = 'Mật khẩu không đúng';

      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      // Khởi tạo GoogleSignIn với config
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        if (mounted) showErrorSnackbar('Người dùng hủy đăng nhập');
        return;
      }

      // Xử lý authentication
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Tạo credential với cả ID token và access token
      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );
      // Đăng nhập Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );
      // Kiểm tra đăng nhập thành công
      if (userCredential.user != null && mounted) {
        // Lưu thông tin user vào Firestore
        await _userService.saveUserToFirestore(userCredential.user!);
        showSuccessSnackbar('Đăng nhập thành công!');
      }
    } on PlatformException catch (e) {
      handlePlatformException(e);
    } catch (e, stack) {
      debugPrint('Google Sign-In Error: $e\n$stack');
      if (mounted) showErrorSnackbar('Lỗi hệ thống: ${e.toString()}');
    }
  }

  void handlePlatformException(PlatformException e) {
    if (mounted) {
      String message = 'Lỗi không xác định';
      switch (e.code) {
        case 'sign_in_failed':
          message = 'Lỗi cấu hình Google Sign-In. Kiểm tra SHA-1 và Client ID';
          break;
        case 'network_error':
          message = 'Lỗi kết nối mạng';
          break;
        case 'internal_error':
          message = 'Lỗi nội bộ từ Google';
          break;
      }
      showErrorSnackbar(message);
    }
  }

  void showErrorSnackbar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Đăng nhập")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  if (!value.contains('@')) {
                    return 'Email không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: "Mật khẩu",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _signInWithEmailPassword,
                  child: const Text("ĐĂNG NHẬP"),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                  ),
                  onPressed: _isLoading ? null : _signInWithGoogle,
                  icon: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/2991/2991148.png',
                    height: 24,
                    width: 24,
                  ),
                  label: const Text("Tiếp tục với Google"),
                ),
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: CircularProgressIndicator(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
