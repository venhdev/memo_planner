part 'habit_constants.dart';

//! Firebase Firestore
// use to define the name of the collection in Firestore
const String pathToUsers = 'users';
const String pathToHabits = 'habits';
const String pathToHabitInstances = 'instances';

// this is pattern use to store date in firestore RRule
const String formatDatePattern = 'yyyyMMdd';
// this is pattern use to display time in app
const String formatTimePattern = 'hh:mm a';


// ------------------  Firebase Constants ------------------
//! Authentication
// The first time run app, user not login
const String kUserNotLogin = 'User not login';

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