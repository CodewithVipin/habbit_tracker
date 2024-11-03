//return todays date formatted as yyyymmdd
String todayDateFormatted() {
  //today
  var dateTimeObject = DateTime.now();

  // year in format of yyyy

  String year = dateTimeObject.year.toString();
  // month in format of mm

  String month = dateTimeObject.month.toString();
  if (month.length == 1) {
    month = '0$month';
  }
  // day in format of dd
  String day = dateTimeObject.day.toString();
  if (day.length == 1) {
    day = '0$day';
  }
  //final format
  String yyyymmdd = year + month + day;
  return yyyymmdd;
}

//convert string yyyymmdd to DateTime Object
DateTime createDateTimeObject(String yyyymmdd) {
  int yyyy = int.parse(yyyymmdd.substring(0, 4));
  int mm = int.parse(yyyymmdd.substring(4, 6));
  int dd = int.parse(yyyymmdd.substring(6, 8));
  DateTime dateTimeObject = DateTime(yyyy, mm, dd);
  return dateTimeObject;
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
