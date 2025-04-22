import 'package:f1/models/enum/snack_bar_type.dart';
import 'package:f1/widgets/customer_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:intl/intl.dart';

class Task {
  final String name;
  final DateTime start;
  final DateTime end;
  final List<String> participants;

  Task({
    required this.name,
    required this.start,
    required this.end,
    required this.participants,
  });
}

Future<void> exportTasksToExcel({
  required BuildContext context,
  required String projectName,
  required List<Task> tasks,
}) async {
  final excel = Excel.createExcel();
  final Sheet sheet = excel[projectName]; // sheet theo projectName

  sheet.appendRow(['Task Name', 'Start Date', 'End Date', 'Participants']);

  final df = DateFormat('yyyy-MM-dd');
  for (var t in tasks) {
    sheet.appendRow([
      t.name,
      df.format(t.start),
      df.format(t.end),
      t.participants.join(', '),
    ]);
  }

  try {
    final bytes = excel.save();
    if (bytes == null || bytes.isEmpty) {
      throw Exception("Dữ liệu Excel trống");
    }

    final dir =
        await getExternalStorageDirectory() ??
        await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$projectName.xlsx';

    final file = File(filePath);
    await file.create(recursive: true);
    await file.writeAsBytes(bytes);

    showCustomSnackBar(
      context, // Cung cấp BuildContext hiện tại
      'Đã tải file Excel thành công.',
      type: SnackBarType.success, // Chỉ định loại là success
      duration: Duration(seconds: 2), // Có thể tùy chỉnh duration ở đây
    );

    debugPrint('Excel file saved to $filePath');
  } catch (e) {
    // Hiển thị thông báo lỗi
    showCustomSnackBar(
      context, // Cung cấp BuildContext hiện tại
      'Đã tải file Excel thành công.',
      type: SnackBarType.error, // Chỉ định loại là success
      duration: Duration(seconds: 2), // Có thể tùy chỉnh duration ở đây
    );

    print('Lỗi khi lưu file: $e');
  }
}
