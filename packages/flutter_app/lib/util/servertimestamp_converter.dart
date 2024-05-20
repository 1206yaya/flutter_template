import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

class ServerTimestampConverter implements JsonConverter<FieldValue, Object?> {
  const ServerTimestampConverter();

  @override
  FieldValue fromJson(Object? timestamp) {
    try {
      return FieldValue.serverTimestamp();
    } catch (e) {
      throw const FormatException('Invalid server timestamp');
    }
  }

  @override
  Object? toJson(FieldValue fieldValue) => fieldValue;
}

final dateFormat = DateFormat('yyyy/MM/dd');
final timeFormat = DateFormat('kk:mm');

String formattedServerTimestamp(dynamic serverTimestamp) {
  DateTime now = DateTime.now();
  
  if (serverTimestamp is DateTime) {
    bool isToday = serverTimestamp.year == now.year &&
        serverTimestamp.month == now.month &&
        serverTimestamp.day == now.day;
    return isToday
        ? timeFormat.format(serverTimestamp)
        : dateFormat.format(serverTimestamp);
  } else if (serverTimestamp is Timestamp) {
    final dateTime = serverTimestamp.toDate();
    bool isToday = dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
    return isToday ? timeFormat.format(dateTime) : dateFormat.format(dateTime);
    // } else if (serverTimestamp == FieldValue.serverTimestamp() ||
    //     serverTimestamp == null) {
    //   // 新規登録時にサーバーによってタイムスタンプが解決される前に serverTimestamp は特別な値となる
    //   return 'Pending Timestamp';
  } else {
    return serverTimestamp.toString();
  }
}
