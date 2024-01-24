import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sigma_task/Screens/home_screen.dart';
import 'package:sigma_task/business_logic/cubit/user_cubit.dart';
import 'package:sigma_task/repository/userRepository.dart';
import 'package:sigma_task/webServices/user_web_service.dart';

class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {

  late UserRepository userRepository;
  late UserCubit userCubit;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userRepository = UserRepository(UserWebService());
    userCubit = UserCubit(userRepository);
  }

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(seconds: 3),(){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (builder) =>
      BlocProvider(
          create: (BuildContext context) =>
            UserCubit(userRepository),
        child: const Home(),
      )));
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset("assets/animes/splash.json"),
          Lottie.asset("assets/animes/splash1.json"),
        ],
      ),
    );
  }
}