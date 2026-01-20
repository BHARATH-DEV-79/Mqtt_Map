import 'package:go_router/go_router.dart';
import 'package:product_api/routes/app_routs.dart';

import '../model/model.dart';
import '../view/Map_page.dart';
import '../view/product_screen.dart';
import '../view/product_screen2.dart';

class AppPages {
  static final GoRouter routes = GoRouter(
    initialLocation: '/home',

    routes: [
      GoRoute(
        path: '/home',
        name: Approute.homeproduct,
        builder: (context, state) => const Homepage(),
      ),
      GoRoute(
        path: '/map',
        name: Approute.mappage,
        builder: (context, state) => const MapPage(),
      ),
      GoRoute(
        name: Approute.product,
        path: '/product',
        builder: (context, state) {
          final Data product = state.extra as Data;

          return Productdetails(data: product);
        },
      ),
    ],
  );
}
