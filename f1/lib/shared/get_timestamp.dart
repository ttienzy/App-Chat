import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String getSmartTimestamp(Timestamp timestamp) {
  // Chuyển đổi Timestamp từ Firebase thành DateTime
  DateTime messageTime = timestamp.toDate();
  DateTime now = DateTime.now();

  // Tạo DateTime cho đầu ngày hôm nay (00:00:00)
  DateTime startOfToday = DateTime(now.year, now.month, now.day);

  // Tạo DateTime cho đầu ngày hôm qua
  DateTime startOfYesterday = startOfToday.subtract(const Duration(days: 1));

  // Tạo DateTime cho đầu tuần này (Thứ Hai)
  DateTime startOfThisWeek = startOfToday.subtract(
    Duration(days: now.weekday - 1),
  );

  // Định dạng theo từng trường hợp
  if (messageTime.isAfter(startOfToday)) {
    // Tin nhắn gửi hôm nay: Hiển thị HH:mm
    return DateFormat('HH:mm').format(messageTime);
  } else if (messageTime.isAfter(startOfYesterday)) {
    // Tin nhắn gửi hôm qua: Hiển thị "Hôm qua HH:mm"
    return 'Hôm qua ${DateFormat('HH:mm').format(messageTime)}';
  } else if (messageTime.isAfter(startOfThisWeek)) {
    // Tin nhắn gửi trong tuần này: Hiển thị "Thứ ... HH:mm"
    List<String> weekdays = [
      'Thứ Hai',
      'Thứ Ba',
      'Thứ Tư',
      'Thứ Năm',
      'Thứ Sáu',
      'Thứ Bảy',
      'Chủ Nhật',
    ];
    String weekday = weekdays[messageTime.weekday - 1];
    return '$weekday ${DateFormat('HH:mm').format(messageTime)}';
  } else if (messageTime.year == now.year) {
    // Tin nhắn gửi trong năm nay: Hiển thị "DD/MM HH:mm"
    return DateFormat('dd/MM HH:mm').format(messageTime);
  } else {
    // Tin nhắn gửi từ năm trước trở về: Hiển thị "DD/MM/YYYY HH:mm"
    return DateFormat('dd/MM/yyyy HH:mm').format(messageTime);
  }
}
