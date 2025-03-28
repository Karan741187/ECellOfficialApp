import 'package:ecellapp/screens/about_us/about_us_new.dart';
import 'package:ecellapp/screens/about_us/tabs/team/cubit/team_cubit_new.dart';
import 'package:ecellapp/screens/about_us/tabs/team/team_repository_new.dart';
import 'package:ecellapp/screens/b_quiz/bquiz.dart';
import 'package:ecellapp/screens/b_quiz/leaderboard_list.dart';
import 'package:ecellapp/screens/gallery/cubit/gallery_cubit.dart';
import 'package:ecellapp/screens/gallery/gallery.dart';
import 'package:ecellapp/screens/gallery/gallery_repository.dart';
import 'package:ecellapp/screens/sponser_new/cubit/sponsors_cubit.dart';
import 'package:ecellapp/screens/sponser_new/sponsors.dart';
import 'package:ecellapp/screens/sponser_new/sponsors_repository.dart';
import 'package:ecellapp/screens/sponsors/sponsorship_head/cubit/sponsors_head_cubit.dart';
import 'package:ecellapp/screens/sponsors/sponsorship_head/sponsors_head_repository.dart';
import 'package:ecellapp/screens/sponsors/sponsorship_head/sponsorship_head.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'core/res/colors.dart';
import 'core/res/strings.dart';
import 'core/themes/app_theme.dart';
import 'core/utils/injection.dart';
import 'models/global_state.dart';
import 'notification_service.dart';
import 'screens/esummit/esummit.dart';
import 'screens/events/cubit/events_cubit.dart';
import 'screens/events/events.dart';
import 'screens/events/events_repository.dart';
import 'screens/home/cubit/feedback_cubit.dart';
import 'screens/home/home.dart';
import 'screens/home/home_repository.dart';
import 'screens/login/cubit/login_cubit.dart';
import 'screens/login/login.dart';
import 'screens/login/login_repository.dart';
import 'screens/signup/cubit/signup_cubit.dart';
import 'screens/signup/signup.dart';
import 'screens/signup/signup_repository.dart';
import 'screens/speaker/cubit/speaker_cubit.dart';
import 'screens/speaker/speaker.dart';
import 'screens/speaker/speaker_repository.dart';
import 'screens/splash/cubit/splash_cubit.dart';
import 'screens/splash/splash.dart';
import 'screens/splash/splash_repository.dart';

///Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: C.backgroundBottom),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  runApp(ECellApp());
}

class ECellApp extends StatefulWidget {
  @override
  State<ECellApp> createState() => _ECellAppState();
}

class _ECellAppState extends State<ECellApp> {
  @override
  void initState() {
    super.initState();
    LocalNotificationService.initialize(context);

    ///gives you the message on which user taps
    ///and it opened the app from terminated state
    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];
        Navigator.of(context).pushNamed(S.routeBQuiz);
      }
    });

    ///forground work
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }
      LocalNotificationService.display(message);
    });

    ///When the app is in background but opened and user taps
    ///on the notification
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];
      Navigator.of(context).pushNamed(S.routeBQuiz);
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return Provider(
      create: (_) => GlobalState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          S.routeSplash: (_) => BlocProvider(
              create: (_) => SplashCubit(FirebaseSplashRepository()),
              child: SplashScreen()),
          S.routeLogin: (_) => BlocProvider(
              create: (_) => LoginCubit(FirebaseLoginRepository()),
              child: LoginScreen()),
          S.routeSignup: (_) => BlocProvider(
              create: (_) => SignupCubit(FirebaseSignUpRepository()),
              child: SignupScreen()),
          S.routeHome: (_) => BlocProvider(
              create: (_) => FeedbackCubit(APIHomeRepository()),
              child: HomeScreen()),
          S.routeSpeaker: (_) => BlocProvider(
              create: (_) => SpeakerCubit(APISpeakerRepository()),
              child: SpeakerScreen()),
          S.routeEvents: (_) => BlocProvider(
              create: (_) =>
                  EventsCubit(APIEventsRepository(), APIEventFormRepository()),
              child: EventsScreen()),
          S.routeSponsors: (_) => BlocProvider(
              create: (_) => SponsorsCubit(APISponsorsRepository()),
              child: SponsorsScreen()),
          S.routeSponsorsHead: (_) => BlocProvider(
              create: (_) => SponsorsHeadCubit(APISponsorsHeadRepository()),
              child: SponsorsHeadScreen()),
          S.routeEsummit: (_) => ESummitScreen(),
          S.routeBQuiz: (_) => BQuiz(),
          S.routeBQuizLeaderboard: (_) => LeaderList(),
          S.routeGallery: (_) => BlocProvider(
              create: (_) => GalleryCubit(APIGalleryRepository()),
              child: GalleryScreen()),
          S.routeAboutUs: (_) => BlocProvider(
              create: (_) => TeamCubitNew(APITeamRepositoryNew()),
              child: AboutUsScreenNew(
                index: 0,
              )),
          S.routeTeam: (_) => BlocProvider(
              create: (_) => TeamCubitNew(APITeamRepositoryNew()),
              child: AboutUsScreenNew(index: 1)),
        },
        initialRoute: S.routeSplash,
        title: "ECellApp",
        theme: AppTheme.themeData(context),
      ),
    );
  }
}
