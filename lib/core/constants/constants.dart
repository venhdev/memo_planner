export 'colors.dart';

class AppConstant {
  static priorityLabel(int priority) {
    switch (priority) {
      case 0:
        return 'Eliminate';
      case 1:
        return 'Delegate';
      case 2:
        return 'Schedule';
      case 3:
        return 'Do Now';
      default:
        return 'Unknown';
    }
  }
}

//! Object type
const String kHabit = 'habit#summary';
const String kHabitInstance = 'habit#instance';
const String kTaskList = 'task#list';
const String kTask = 'task#instance';

/*
 * /habits/ [habit#summary] / instances [habit#instance]
 * /tasks/ [task#list] / task / [task#instance]
 */

//! Firebase Firestore
// use to define the name of the collection in Firestore
const String pathToUsers = 'users'; //* /users/{email}
const String pathToHabits = 'habits'; //* /habits/{hid}
//* /habits/ {hid} / <email> / {iid}
// const String pathToHabitInstances = 'instances'; *deprecated => user's email is used as collection path
const String pathToGroups = 'groups'; //* /groups/{gid}
const String pathToTaskLists = 'task-lists'; //* /tasks/{tid}
const String pathToTasks = 'tasks'; //* /tasks/{tid}/instances/{iid}
const String pathToMyDay = 'myday'; //* /users/{email}/myday/{tid}

// this is pattern use to store date in firestore RRule
const String kDateFormatPattern = 'yyyyMMdd';
// this is pattern use to display time in app
const String kTimeFormatPattern = 'hh:mm a';

// ------------------  Firebase Constants ------------------
//! Authentication
// The first time run app, user not login
const String kUserNotLogin = 'Please login to continue!';

const String kSignInFailMessage = 'Login failed';
const String kSignInSuccessMessage = 'Login failed';

const String kSignUpFailMessage = 'Sign up failed';
const String kSignUpSuccessMessage = 'Sign up success';

const String kSignOutFailMessage = 'Sign out failed';
const String kSignOutSuccessMessage = 'Sign out success';

//* FirebaseAuth -- Email/Password
// invalid-email
const String kAuthInvalidEmail = 'Invalid email';
// INVALID_LOGIN_CREDENTIALS -- wrong email/password
const String kAuthInvalidLoginCredentials = 'Invalid login credentials';
// too-many-requests
const String kAuthTooManyRequests = 'You have tried too many times. Please try again later';
// network-request-failed
const String kAuthNetworkRequestFailed = 'Your network is not stable';

//? ----------- has not been caught yet -----------
// // user-not-found
// const String kAuthUserNotFound = 'User not found';

// ! Notification channel id
const String kDefaultNotificationChannelId = 'default_notification';
const String kScheduleNotificationChannelId = 'schedule_notification';
const String kDailyNotificationChannelId = 'daily_notification';
