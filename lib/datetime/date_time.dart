//return todays date formatted as yyyymmdd
String todayDateFormatted() {
  var dateTimeObject = DateTime.now();

  String year = dateTimeObject.year.toString();
  String month = dateTimeObject.month.toString().padLeft(2, '0');
  String day = dateTimeObject.day.toString().padLeft(2, '0');

  return '$year$month$day'; // Return in "yyyymmdd" format
}

//convert string yyyymmdd to DateTime Object
DateTime createDateTimeObject(String yyyymmdd) {
  try {
    int yyyy = int.parse(yyyymmdd.substring(0, 4));
    int mm = int.parse(yyyymmdd.substring(4, 6));
    int dd = int.parse(yyyymmdd.substring(6, 8));

    return DateTime(yyyy, mm, dd); // Return as DateTime object
  } catch (e) {
    return DateTime.now(); // Fallback to current date in case of an error
  }
}

//convert DateTime object to string yyymmdd

String convertDateTimeToString(DateTime dateTime) {
  // year in the format of yyyy
  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  String day = dateTime.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  //final format
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}
