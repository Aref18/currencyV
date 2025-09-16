import 'package:shamsi_date/shamsi_date.dart';

String getShamsiDateTime() {
  DateTime now = DateTime.now();
  Jalali jNow = Jalali.fromDateTime(now);
  return '${jNow.year}/${jNow.month}/${jNow.day} - ${now.hour}:${now.minute}';
}
