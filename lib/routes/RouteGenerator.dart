import 'package:band_hub/ui/authentication/continue_with_phone_screen.dart';
import 'package:band_hub/ui/authentication/forgot_password_screen.dart';
import 'package:band_hub/ui/authentication/login_screen.dart';
import 'package:band_hub/ui/authentication/setup_profile_screen.dart';
import 'package:band_hub/ui/authentication/sign_up_screen.dart';
import 'package:band_hub/ui/authentication/verification_screen.dart';
import 'package:band_hub/ui/bookings/bookings_screen.dart';
import 'package:band_hub/ui/groupChat/group_chat_screen.dart';
import 'package:band_hub/ui/groupChat/see_members_screen.dart';
import 'package:band_hub/ui/intro_screens.dart';
import 'package:band_hub/ui/manager/event/create_event_screen.dart';
import 'package:band_hub/ui/manager/event/favourite_event_screen.dart';
import 'package:band_hub/ui/manager/event/manager_event_detail_screen.dart';
import 'package:band_hub/ui/manager/event/musican_detail_screen.dart';
import 'package:band_hub/ui/manager/event/musician_category_screen.dart';
import 'package:band_hub/ui/manager/event/nearby_musician_screen.dart';
import 'package:band_hub/ui/manager/home/manager_home_screen.dart';
import 'package:band_hub/ui/manager/home/view_all_events_screen.dart';
import 'package:band_hub/ui/manager/map/map_screen.dart';
import 'package:band_hub/ui/manager/messeges/provider_message_screen.dart';
import 'package:band_hub/ui/manager/orders/my_orders_screen.dart';
import 'package:band_hub/ui/manager/profile/manager_profile_screen.dart';
import 'package:band_hub/ui/manager/profile/new_profile_screen.dart';
import 'package:band_hub/ui/manager/profile/profile_screen.dart';
import 'package:band_hub/ui/manager/settings/manages_settings_screen.dart';
import 'package:band_hub/ui/notification/notification_screen.dart';
import 'package:band_hub/ui/rating/event_rating_screen.dart';
import 'package:band_hub/ui/rating/rating_screen.dart';
import 'package:band_hub/ui/rating/review_screen.dart';
import 'package:band_hub/ui/setting/change_password_screen.dart';
import 'package:band_hub/ui/setting/privacy_terms_about_screen.dart';
import 'package:band_hub/ui/splash_screen.dart';
import 'package:band_hub/ui/user/home/booking/booking_deatail_screen.dart';
import 'package:band_hub/ui/user/home/booking/user_booking_screen.dart';
import 'package:band_hub/ui/user/home/event_detail_screen.dart';
import 'package:band_hub/ui/user/home/message/user_chat_screen.dart';
import 'package:band_hub/ui/user/home/user_home_screen.dart';
import 'package:band_hub/ui/user/profile/user_profile_screen.dart';
import 'package:band_hub/ui/user/user_main_screen.dart';
import 'package:flutter/material.dart';

import 'Routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    Widget widgetScreen;
    switch (settings.name) {

      //Common Screens
      case Routes.splashScreen:
        widgetScreen = const SplashScreen();
        break;
      case Routes.introScreen:
        widgetScreen = const IntroScreen();
        break;
      case Routes.logInScreen:
        widgetScreen = const LoginScreen();
        break;
      case Routes.forgotPasswordScreen:
        widgetScreen = const ForgotPasswordScreen();
        break;
      case Routes.signUpScreen:
        widgetScreen = const SignUpScreen();
        break;
      case Routes.setupProfileScreen:
        widgetScreen = const SetupProfileScreen();
        break;
      case Routes.ratingScreen:
        widgetScreen = const RatingScreen();
        break;
      case Routes.reviewScreen:
        widgetScreen = const ReviewScreen();
        break;
      case Routes.notificationScreen:
        widgetScreen = const NotificationScreen();
        break;
      case Routes.changePasswordScreen:
        widgetScreen = const ChangePasswordScreen();
        break;
      case Routes.privacyTermsAboutScreen:
        widgetScreen = const PrivacyTermsAboutScreen();
        break;
      case Routes.bookingScreen:
        widgetScreen = const BookingScreen();
        break;
      case Routes.continueWithPhoneScreen:
        widgetScreen = const ContinueWithPhoneScreen();
        break;
      case Routes.verificationScreen:
        widgetScreen = const VerificationScreen();
        break;
      case Routes.eventRatingScreen:
        widgetScreen = const EventRatingScreen();
        break;
      case Routes.groupChatScreen:
        widgetScreen = const GroupChatScreen();
        break;
      case Routes.seeMembersScreen:
        widgetScreen = const SeeMembersScreen();
        break;

      // User Screens
      case Routes.userMainScreen:
        widgetScreen = const UserMainScreen();
        break;
      case Routes.userHomeScreen:
        widgetScreen = const UserHomeScreen();
        break;
      case Routes.userBookingScreen:
        widgetScreen = const UserBookingScreen();
        break;
      case Routes.eventDetailScreen:
        widgetScreen = const EventDetailScreen();
        break;
      case Routes.bookingDetailScreen:
        widgetScreen = const BookingDetailScreen();
        break;
      case Routes.userChatScreen:
        widgetScreen = const UserChatScreen();
        break;
      case Routes.userProfileScreen:
        widgetScreen = const UserProfileScreen();
        break;

      //Manager Screens
      case Routes.managerHomeScreen:
        widgetScreen = const ManagerHomeScreen();
        break;
      case Routes.viewAllEventsScreen:
        widgetScreen = const ViewAllEventsScreen();
        break;
      case Routes.createEventScreen:
        widgetScreen = const CreateEventScreen();
        break;
      case Routes.profileScreen:
        widgetScreen = const ProfileScreen();
        break;
      case Routes.myOrdersScreen:
        widgetScreen = const MyOrdersScreen();
        break;
      case Routes.managerSettingsScreen:
        widgetScreen = const ManagerSettingsScreen();
        break;
      case Routes.favouriteEventScreen:
        widgetScreen = const FavouriteEventScreen();
        break;
      case Routes.managerEventDetailScreen:
        widgetScreen = const ManagerEventDetailScreen();
        break;
      case Routes.musicianCategoryScreen:
        widgetScreen = const MusicianCategoryScreen();
        break;
      case Routes.nearbyMusicianScreen:
        widgetScreen = const NearbyMusicianScreen();
        break;
      case Routes.musicianDetailScreen:
        widgetScreen = const MusicianDetailScreen();
        break;
      case Routes.managerProfileScreen:
        widgetScreen = const ManagerProfileScreen();
        break;
      case Routes.providerMessageScreen:
        widgetScreen = const ProviderMessageScreen();
        break;
      case Routes.newProfileScreen:
        widgetScreen = const NewProfileScreen();
        break;
      case Routes.mapScreen:
        widgetScreen = const MapScreen();
        break;
      default:
        widgetScreen = _errorRoute();
    }

    return PageRouteBuilder(
        settings: settings, pageBuilder: (_, __, ___) => widgetScreen);
  }

  static Widget _errorRoute() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: const Center(
        child: Text(
          'No such screen found in route generator',
        ),
      ),
    );
  }
}
