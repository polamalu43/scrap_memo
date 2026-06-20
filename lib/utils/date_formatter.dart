String formatDateTime(DateTime dateTime) {
  String pad(int value) => value.toString().padLeft(2, '0');
  return '${dateTime.year}-${pad(dateTime.month)}-${pad(dateTime.day)} '
      '${pad(dateTime.hour)}:${pad(dateTime.minute)}';
}
