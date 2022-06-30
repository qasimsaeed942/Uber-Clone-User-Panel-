
import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_app/models/direction_details_info.dart';
import 'package:users_app/models/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentFirebaseUser;
UserModel? userModelCurrentInfo;
List dList = []; //driver keys Info  list
DirectionDetailsInfo? tripDirectionDetailsInfo;
String? chosenDriverId = "";
String cloudMessagingServerToken = "key=AAAAGzgKKyc:APA91bEBJpbnhYdwKHHl5jiH57iUxk7LP2z-Ov4BGv5A7bg7kqnWBiSwAsOMWwKsgIP_98RZg9KBFsREUgBYGHXxBxgYveBw4OY0TiqeKyFYxXBhpOsNMLDC84Uf8yJRksv-T8PIwlph";
String userDropOffAddress = "";
String driverCarDetails = "";
String driverName = "";
String driverPhone= "";
double countRatingStars = 0.0;
String titleStarsRating = "";
