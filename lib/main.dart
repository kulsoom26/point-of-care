// import 'package:firebase_core/firebase_core.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:test/constants/const.dart';
import 'package:test/firebase_options.dart';
import 'package:test/providers/appointment_services.dart';
import 'package:test/providers/auth.dart';
import 'package:test/providers/doctor.dart';
import 'package:test/providers/feedback.dart';
import 'package:test/providers/patient.dart' as patient;
import 'package:test/providers/radiologist.dart';
import 'package:test/providers/results.dart';
import 'package:test/providers/user_provider.dart';
import 'package:test/screens/Appointments/screens/availableDoctors.dart';
import 'package:test/screens/Diagnosis/screens/diagnosis.dart';
import 'package:test/screens/Diagnosis/screens/selectDiagnosis.dart';
import 'package:test/screens/Doctor%20Recommendation/screens/nearbyDoctors.dart';
import 'package:test/screens/Feedback%20and%20Settings/screens/setting.dart';
import 'package:test/screens/Main/screens/aboutUs.dart';
import 'package:test/screens/Main/screens/homeScreen.dart';
import 'package:test/screens/Main/screens/tabScreen.dart';
import 'package:test/screens/Result%20and%20Reporting/screens/resultScreen.dart';
import 'package:test/screens/Result%20and%20Reporting/screens/reportList.dart';
import 'package:test/screens/User%20Profiling/screens/addProfile.dart';
import 'package:test/screens/User%20Profiling/screens/authentication.dart';
import 'package:test/screens/User%20Profiling/screens/editProfile.dart';
import 'package:test/screens/User%20Profiling/screens/email-otp.dart';
import 'package:test/screens/User%20Profiling/screens/profile.dart';
import 'providers/reports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51OLPrsJlgl4sLrLcZr1pSVhTDqSRP2dExmzx8rrOdrmZcfcA4jyX6kKF3VBI2FsG09wY1mMvoD6E6OlLJPciv7U4000Az18Wjm';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialColor createMaterialColor(Color color) {
      List strengths = <double>[.05];
      Map<int, Color> swatch = {};
      final int r = color.red, g = color.green, b = color.blue;

      for (int i = 1; i < 10; i++) {
        strengths.add(0.1 * i);
      }
      for (var strength in strengths) {
        final double ds = 0.5 - strength;
        swatch[(strength * 1000).round()] = Color.fromRGBO(
          r + ((ds < 0 ? r : (255 - r)) * ds).round(),
          g + ((ds < 0 ? g : (255 - g)) * ds).round(),
          b + ((ds < 0 ? b : (255 - b)) * ds).round(),
          1,
        );
      }
      return MaterialColor(color.value, swatch);
    }

    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(
            create: (ctx) => Auth.toauth(),
          ),
          ChangeNotifierProvider<Results>(
            create: (ctx) => Results(),
          ),
          ChangeNotifierProvider<Doctor>(
            create: (ctx) => Doctor.fromdoc(),
          ),
          ChangeNotifierProvider<patient.Patient>(
            create: (ctx) => patient.Patient.frompat(),
          ),
          ChangeNotifierProvider<Radiologist>(
            create: (ctx) => Radiologist.fromrad(),
          ),
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => AppointmentServices(),
          ),
          ChangeNotifierProvider<Reports>(
            create: (ctx) => Reports(),
          ),
          ChangeNotifierProvider(
            create: (_) => FeedbackServices(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) => MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Point-Of-Care',
            theme: ThemeData(
                primarySwatch: createMaterialColor(primaryColor),
                scaffoldBackgroundColor: Colors.white,
                fontFamily: 'Poppins'),
            home: auth.userId != null ? TabsScreen() : Authentication(),
            routes: {
              TabsScreen.routeName: (ctx) => TabsScreen(),
              HomeScreen.routeName: (ctx) => HomeScreen(),
              SettingScreen.routeName: (ctx) => const SettingScreen(),
              Profile.routeName: (ctx) => Profile(),
              AboutUs.routeName: (ctx) => AboutUs(),
              Diagnosis.routeName: (ctx) => Diagnosis(),
              NearbyDoctors.routeName: (ctx) => const NearbyDoctors(),
              ResultScreen.routeName: (ctx) => ResultScreen(),
              DoctorProfile.routeName: (ctx) => DoctorProfile(),
              ReportList.routeName: (ctx) => ReportList(),
              SelectDiagnosis.routeName: (ctx) => const SelectDiagnosis(),
              EditProfile.routeName: (ctx) => const EditProfile(),
              EmailOtp.routeName: (ctx) => const EmailOtp(),
              AvailableDoctorsScreen.routeName: (ctx) =>
                  const AvailableDoctorsScreen()
            },
          ),
        ));
  }
}
