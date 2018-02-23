/*
 *  Date and Time utilities written in Javascript for ethereum contracts
 *
 */

var DAY_IN_SECONDS = 86400;
var YEAR_IN_SECONDS = 31536000;
var LEAP_YEAR_IN_SECONDS = 31622400;
var HOUR_IN_SECONDS = 3600;
var MINUTE_IN_SECONDS = 60;
var ORIGIN_YEAR = 1970;

var PLAYING_TIME = 3 * HOUR_IN_SECONDS;
var RESULT_TIME = 18 * HOUR_IN_SECONDS;


function isLeapYear(year) {
  if (year % 4 != 0) {
    return false;
  }
  if (year % 100 != 0) {
    return true;
  }
  if (year % 400 != 0) {
    return false;
  }
  return true;
}

function leapYearsBefore(year) {
  year -= 1;
  return parseInt(year / 4 - year / 100 + year / 400);
}

function getDaysInMonth(month, year) {
  if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12) {
    return 31;
  }
  else if (month == 4 || month == 6 || month == 9 || month == 11) {
    return 30;
  }
  else if (isLeapYear(year)) {
    return 29;
  }
  else {
    return 28;
  }
}

function parseTimestamp(timestamp) {
  var secondsAccountedFor = 0;
  var buf;
  var i;
  var dt = {}; // datetime
  // Year
  dt.year = getYear(timestamp);

  timestamp += 9 * HOUR_IN_SECONDS;

  buf = leapYearsBefore(dt.year) - leapYearsBefore(ORIGIN_YEAR);
  secondsAccountedFor += LEAP_YEAR_IN_SECONDS * buf;
  secondsAccountedFor += YEAR_IN_SECONDS * (dt.year - ORIGIN_YEAR - buf);
  // Month
  var secondsInMonth;
  for (i = 1; i <= 12; i++) {
    secondsInMonth = DAY_IN_SECONDS * getDaysInMonth(i, dt.year);
    if (secondsInMonth + secondsAccountedFor > timestamp) {
      dt.month = i;
      break;
    }
    secondsAccountedFor += secondsInMonth;
  }
  // Day
  for (i = 1; i <= getDaysInMonth(dt.month, dt.year); i++) {
    if (DAY_IN_SECONDS + secondsAccountedFor > timestamp) {
      dt.day = i;
      break;
    }
    secondsAccountedFor += DAY_IN_SECONDS;
  }
  // Hour
  dt.hour = getHour(timestamp);
  // Minute
  dt.minute = getMinute(timestamp);
  // Second
  dt.second = getSecond(timestamp);
  // Day of week.
  dt.weekday = getWeekday(timestamp);
  return dt;
}

function getYear(timestamp) {
  var secondsAccountedFor = 0;
  var year;
  var numLeapYears;
  timestamp += 9 * HOUR_IN_SECONDS;
  // Year
  year = parseInt(ORIGIN_YEAR + timestamp / YEAR_IN_SECONDS);
  numLeapYears = leapYearsBefore(year) - leapYearsBefore(ORIGIN_YEAR);
  secondsAccountedFor += LEAP_YEAR_IN_SECONDS * numLeapYears;
  secondsAccountedFor += YEAR_IN_SECONDS * (year - ORIGIN_YEAR - numLeapYears);
  while (secondsAccountedFor > timestamp) {
    if (isLeapYear(year - 1)) {
      secondsAccountedFor -= LEAP_YEAR_IN_SECONDS;
    }
    else {
      secondsAccountedFor -= YEAR_IN_SECONDS;
    }
    year -= 1;
  }
  return year;
}
function getMonth(timestamp) {
  return parseTimestamp(timestamp).month;
}
function getDay(timestamp) {
  return parseTimestamp(timestamp).day;
}
function getHour(timestamp) {
  return parseInt(timestamp / 60 / 60) % 24;
}
function getMinute(timestamp) {
  return parseInt(timestamp / 60) % 60;
}
function getSecond(timestamp) {
  return timestamp % 60;
}
function getWeekday(timestamp) {
  return parseInt(timestamp / DAY_IN_SECONDS + 4) % 7;
}


function toTimestamp(year, month, day, hour, minute, second) {
  var i;
  var timestamp = 0;
  // Year
  for (i = ORIGIN_YEAR; i < year; i++) {
    if (isLeapYear(i)) {
      timestamp += LEAP_YEAR_IN_SECONDS;
    }
    else {
      timestamp += YEAR_IN_SECONDS;
    }
  }

  // Month
  var monthDayCounts = [ 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ];
  if (isLeapYear(year)) {
    monthDayCounts[1] = 29;
  }
  for (i = 1; i < month; i++) {
    timestamp += DAY_IN_SECONDS * monthDayCounts[i - 1];
  }
  // Day
  timestamp += DAY_IN_SECONDS * (day - 1);
  // Hour
  timestamp += HOUR_IN_SECONDS * (hour);
  // Minute
  timestamp += MINUTE_IN_SECONDS * (minute);
  // Second
  timestamp += second;

  return timestamp - 9 * HOUR_IN_SECONDS;
}

function getStatus(startTime){
  let date = new Date();
  let now = toTimestamp(date.getFullYear(), date.getMonth()+1, date.getDate(), date.getHours(), date.getMinutes(), date.getSeconds());

  if (now < startTime) return 0;  // Betting
  else if (now >= startTime && now < startTime + PLAYING_TIME) return 1;  // Playing
  else if (now >= startTime + PLAYING_TIME && now < startTime + PLAYING_TIME + RESULT_TIME) return 2;  // Result
  else if (now >= startTime + PLAYING_TIME + RESULT_TIME) return 3; // Reward
  else return -1;
}
