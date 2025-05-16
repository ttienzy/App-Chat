import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

String convertTimestampToDate(Timestamp timestamp) {
  // Chuyển timestamp sang DateTime
  DateTime date = timestamp.toDate();

  // Format lại theo dd/MM/yyyy
  return DateFormat('dd/MM/yyyy').format(date);
}

String formatAuthTime(String isoTime) {
  try {
    final utcTime = DateTime.parse(isoTime);
    final localTime = utcTime.toLocal(); // Chuyển sang múi giờ địa phương

    return DateFormat('dd/MM/yyyy').format(localTime); // Format: 25/02/2025
  } catch (e) {
    return 'Invalid date';
  }
}
