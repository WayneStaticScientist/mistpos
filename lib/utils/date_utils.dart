class MistDateUtils {
  static String formatMonthAndDay(DateTime dateTime) {
    return "${_getMonthName(dateTime.month)} ${dateTime.day}";
  }

  static formatNormalDate(DateTime dateTime) {
    return "${getWeekDayName(dateTime)} ${dateTime.day} ${_getMonthName(dateTime.month)} ${dateTime.year}";
  }

  static String getInformalDate(DateTime dateTime) {
    return "${_getMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}";
  }

  static String getInformalShortDate(DateTime dateTime) {
    return "${_getShortMonthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}";
  }

  static String getWeekDayName(DateTime dateTime) {
    switch (dateTime.weekday) {
      case DateTime.monday:
        return "Monday";
      case DateTime.tuesday:
        return "Tuesday";
      case DateTime.wednesday:
        return "Wednesday";
      case DateTime.thursday:
        return "Thursday";
      case DateTime.friday:
        return "Friday";
      case DateTime.saturday:
        return "Saturday";
      case DateTime.sunday:
        return "Sunday";
      default:
        return "";
    }
  }

  static String _getMonthName(int month) {
    switch (month) {
      case 1:
        return "January";
      case 2:
        return "February";
      case 3:
        return "March";
      case 4:
        return "April";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "";
    }
  }

  static String _getShortMonthName(int month) {
    switch (month) {
      case 1:
        return "Jan";
      case 2:
        return "Feb";
      case 3:
        return "Mar";
      case 4:
        return "Apr";
      case 5:
        return "May";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "Aug";
      case 9:
        return "Sept";
      case 10:
        return "Oct";
      case 11:
        return "Nov";
      case 12:
        return "Dec";
      default:
        return "";
    }
  }
}
