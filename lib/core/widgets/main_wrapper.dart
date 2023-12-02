import 'package:flutter/material.dart';
import 'package:flutteradvanced/core/widgets/app_background.dart';
import 'package:flutteradvanced/core/widgets/bottonm_nav.dart';
import '../../features/feature_bookmark/presentation/screens/bookmark_screen.dart';
import '../../features/feature_weather/presentation/screens/home_screen.dart';

class MainWrapper extends StatelessWidget {
  MainWrapper({Key? key}) : super(key: key);

  final PageController pageController=PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    List<Widget> pageViewWidget=[
      const HomeScreen(),
      BookMarkScreen(pageController: pageController,),
    ];
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: BottomNav(pageController: pageController),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AppBackground.getBackGroundImage(),
            fit: BoxFit.cover,

          ),

        ),
        height: height,
        child: PageView(
          controller: pageController,
          children: pageViewWidget,
        ),
      ),
    );
  }
}

// class MainWrapper extends StatefulWidget {
//   const MainWrapper({Key? key}) : super(key: key);
//
//   @override
//   State<MainWrapper> createState() => _MainWrapperState();
// }
//
// class _MainWrapperState extends State<MainWrapper> {
//
//   @override
//   void initState() {
//     super.initState();
//     BlocProvider.of<HomeBloc>(context).add(LoadCwEvent("tehran"));
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//       body: BlocBuilder<HomeBloc,HomeState> (
//         builder: (context,state){
//           if(state.cwStatus is CwLoading){
//             return const Center(child: Text("Loading.."),);
//           }
//           if(state.cwStatus is CwCompleted){
//
//             /// cast
//             final CwCompleted cwCompleted=state.cwStatus as CwCompleted;
//             final CurrentCityEntity currentCityEntity=cwCompleted.currentCityEntity;
//
//             return  Center(child: Text(currentCityEntity.clouds.toString()),);
//           }
//           if(state.cwStatus is CwError){
//             return const Center(child: Text("Error.."),);
//           }
//           return Container();
//         },
//       ),
//     );
//   }
//
// }
