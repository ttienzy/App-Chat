import 'package:f1/models/enum/snack_bar_type.dart';
import 'package:flutter/material.dart';

// Hàm helper để hiển thị SnackBar tùy chỉnh
void showCustomSnackBar(
  BuildContext context,
  String message, {
  SnackBarType type = SnackBarType.info, // Mặc định là kiểu thông tin
  Duration duration = const Duration(seconds: 3),
  SnackBarAction? action,
}) {
  // --- Chọn Icon và Màu sắc dựa trên loại SnackBar ---
  IconData iconData;
  Color backgroundColor;
  // Màu cho text và icon, đảm bảo tương phản tốt với nền
  Color contentColor = Colors.white;

  switch (type) {
    case SnackBarType.success:
      iconData = Icons.check_circle_outline;
      // Sử dụng màu xanh lá cây rõ ràng cho thành công
      backgroundColor = Color(0xFF388E3C); // Colors.green[700]
      break;
    case SnackBarType.error:
      iconData = Icons.error_outline;
      // Sử dụng màu đỏ rõ ràng cho lỗi
      backgroundColor = Color(0xFFD32F2F); // Colors.red[700]
      break;
    case SnackBarType.warning:
      iconData = Icons.warning_amber_rounded;
      // Sử dụng màu cam/vàng cho cảnh báo
      backgroundColor = Color(0xFFFFA000); // Colors.amber[700]
      break;
    case SnackBarType.info:
    default: // Mặc định hoặc kiểu info
      iconData = Icons.info_outline;
      // Sử dụng màu xanh dương hoặc màu tối trung tính
      backgroundColor = Color(0xFF1976D2); // Colors.blue[700]
      // Hoặc một màu tối hơn: backgroundColor = Colors.black.withOpacity(0.8);
      break;
  }

  // --- Tạo Widget SnackBar ---
  final snackBar = SnackBar(
    content: Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Căn giữa theo chiều dọc
      children: [
        Icon(iconData, color: contentColor, size: 24.0), // Kích thước icon
        const SizedBox(width: 12.0), // Tăng khoảng cách một chút
        Expanded(
          child: Text(
            message,
            style: TextStyle(
              color: contentColor,
              fontSize: 15.0, // Cỡ chữ phù hợp
              fontWeight: FontWeight.w500, // Độ đậm vừa phải
            ),
            maxLines: 3, // Giới hạn số dòng nếu text quá dài
            overflow: TextOverflow.ellipsis, // Thêm dấu ... nếu tràn
          ),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    // Hiệu ứng nổi và bo góc cho giao diện hiện đại
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0), // Bo góc mềm mại
    ),
    // Thêm margin để tạo khoảng cách khi floating
    margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
    // Độ nâng tạo bóng đổ nhẹ
    elevation: 6.0,
    action: action,
  );

  // --- Hiển thị SnackBar ---
  // Xóa SnackBar hiện tại (nếu có) trước khi hiển thị cái mới
  // giúp tránh chồng chéo và tạo cảm giác mượt hơn
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
