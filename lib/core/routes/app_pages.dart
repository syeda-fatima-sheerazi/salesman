import 'package:get/get.dart';
import 'package:practices/core/models/shop.dart';
import 'package:practices/core/models/user_model.dart';
import 'package:practices/core/screens/home/detailed/detailed_view_binding.dart';
import 'package:practices/core/screens/products/add_product/add_product_binding.dart';
import 'package:practices/core/screens/add_shop/add_shop_binding.dart';
import 'package:practices/core/screens/dashboard/dashboard_binding.dart';
import 'package:practices/core/screens/login/login_binding.dart';
import 'package:practices/core/screens/place_order/place_order_binding.dart';
import 'package:practices/core/screens/profile/profile_binding.dart';
import 'package:practices/core/screens/signUp/signup_binding.dart';
import 'package:practices/core/screens/splash/splash_binding.dart';
import 'package:practices/core/routes/route_names.dart';
import 'package:practices/core/screens/add_shop/add_shop_view.dart';
import 'package:practices/core/screens/dashboard/dashboard_view.dart';
import 'package:practices/core/screens/home/detailed/detailed_view.dart';
import 'package:practices/core/screens/login/login_view.dart';
import 'package:practices/core/screens/notifications/notifications_view.dart';
import 'package:practices/core/screens/place_order/place_order_view.dart';
import 'package:practices/core/screens/products/add_product/add_product_view.dart';
import 'package:practices/core/screens/products/products_view.dart';
import 'package:practices/core/screens/signUp/sign_up_view.dart';
import 'package:practices/core/screens/splash/splash_view.dart';
import 'package:practices/core/screens/todo/todo_view.dart';
import 'package:practices/core/screens/profile/profile_view.dart';
import 'package:practices/core/screens/home/home_view.dart';
import 'package:practices/core/screens/analytics/analytics_view.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = <GetPage<dynamic>>[
    GetPage(
      name: Routes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: Routes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: Routes.signup,
      page: () => const SignUpView(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: Routes.dashboard,
      page: () {
        // return DashboardView(
        //   user: UserModel(id: "id", name: "name", email: "email"),
        // );
        final arguments = Get.arguments;
        if (arguments is UserModel) {
          return DashboardView(user: arguments);
        }
        throw ArgumentError(
          'Expected a UserModel object as Get.arguments for ${Routes.dashboard}, but got ${arguments.runtimeType}',
        );
      },
      binding: DashboardBinding(),
    ),
    GetPage(name: Routes.home, page: () => const HomeView()),
    GetPage(
      name: Routes.addShop,
      page: () => const AddShopView(),
      binding: AddShopBinding(),
    ),
    GetPage(
      name: Routes.placeOrder,
      page: () {
        final arguments = Get.arguments;
        if (arguments is Shop) {
          return PlaceOrderView(shop: arguments);
        }
        throw ArgumentError(
          'Expected a Shop object as Get.arguments for ${Routes.placeOrder}, but got ${arguments.runtimeType}',
        );
      },
      binding: PlaceOrderBinding(),
    ),
    GetPage(name: Routes.products, page: () => const ProductsView()),
    GetPage(
      name: Routes.addProduct,
      page: () => const AddProductView(),
      binding: AddProductBinding(),
    ),
    GetPage(name: Routes.notifications, page: () => const NotificationsView()),
    GetPage(name: Routes.todo, page: () => const TodoView()),
    GetPage(name: Routes.statement, page: () => const AnalyticsView()),
    GetPage(
      name: Routes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: Routes.detailed,
      page: () {
        final arguments = Get.arguments;
        if (arguments is Shop) {
          return DetailedView(shop: arguments);
        }
        throw ArgumentError(
          'Expected a Shop object as Get.arguments for ${Routes.detailed}, but got ${arguments.runtimeType}',
        );
      },
      binding: DetailedViewBinding(),
    ),
  ];
}
