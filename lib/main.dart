import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controller/controller.dart';
import 'routes/app_pages.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const Mainclass());
}

class Mainclass extends StatelessWidget {
  const Mainclass({super.key});

  @override

  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductController()),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppPages.routes,
      ),
    );
  }
}