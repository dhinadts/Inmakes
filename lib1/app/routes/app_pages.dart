import 'package:get/get.dart';

import '../common_ui/auth_wrapper.dart';
import '../modules/admin_dashboard/bindings/admin_dashboard_binding.dart';
import '../modules/admin_dashboard/views/admin_dashboard_view.dart';
import '../modules/admob_helper/bindings/admob_helper_binding.dart';
import '../modules/admob_helper/views/admob_helper_view.dart';
import '../modules/dashboard/bindings/dashboard_binding.dart';
import '../modules/dashboard/views/dashboard_view.dart';
import '../modules/food-description/bindings/food_description_binding.dart';
import '../modules/food-description/views/food_description_view.dart';
import '../modules/food-order-management/bindings/food_order_management_binding.dart';
import '../modules/food-order-management/views/food_order_management_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/order_food/bindings/order_food_binding.dart';
import '../modules/order_food/views/order_food_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/restaurant_management/bindings/restaurant_management_binding.dart';
import '../modules/restaurant_management/views/restaurant_management_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';
import '../modules/user_dashboard/bindings/user_dashboard_binding.dart';
import '../modules/user_dashboard/views/user_dashboard_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static const LOGIN = Routes.LOGIN;
  static const REGISTER = Routes.REGISTER;
  static const SPLASH_SCREEN = Routes.SPLASH_SCREEN;
  static const AUTH_WRAPPER = Routes.AUTH_WRAPPER;
  static const DASHBOARD = Routes.DASHBOARD;
  static const ADMOB_HELPER = Routes.ADMOB_HELPER;
  static const ADMIN_DASHBOARD = Routes.ADMIN_DASHBOARD;
  static const USER_DASHBOARD = Routes.USER_DASHBOARD;

  static const SETTINGS = Routes.SETTINGS;
  static const ORDER_FOOD = Routes.ORDER_FOOD;
  static const RESTAURANT_MANAGEMENT = Routes.RESTAURANT_MANAGEMENT;
  static const FOOD_ORDER_MANAGEMENT = Routes.FOOD_ORDER_MANAGEMENT;

  static final routes = [
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
      arguments: [
        {"role": "", "userId": ""},
      ],
    ),
    GetPage(name: Routes.AUTH_WRAPPER, page: () => AuthWrapper()),
    GetPage(
      name: _Paths.ADMOB_HELPER,
      page: () => const AdmobHelperView(),
      binding: AdmobHelperBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.USER_DASHBOARD,
      page: () => const UserDashboardView(),
      binding: UserDashboardBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.ORDER_FOOD,
      page: () => const OrderFoodView(),
      binding: OrderFoodBinding(),
    ),
    GetPage(
      name: _Paths.RESTAURANT_MANAGEMENT,
      page: () => const RestaurantManagementView(),
      binding: RestaurantManagementBinding(),
    ),
    GetPage(
      name: _Paths.FOOD_ORDER_MANAGEMENT,
      page: () => const FoodOrderListView(),
      binding: FoodOrderManagementBinding(),
    ),
    GetPage(
      name: _Paths.FOOD_DESCRIPTION,
      page: () => const FoodDescriptionView(),
      binding: FoodDescriptionBinding(),
    ),
  ];
}
