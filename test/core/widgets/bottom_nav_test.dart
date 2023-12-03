import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutteradvanced/core/widgets/bottonm_nav.dart';

void main() {
  testWidgets(
      'click IconButton in bottom nav should moving to page 0 in pageView', (
      tester) async
  {
    final PageController pageController = PageController();
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      bottomNavigationBar: BottomNav(pageController: pageController,),
      body: PageView(
        controller: pageController,
        children: [
          Container(),
          Container()
        ],
      ),
    ),
    ),
    );
    await tester.tap(find.widgetWithIcon(IconButton, Icons.home));
    // rebuild widget
    await tester.pumpAndSettle();
    
    expect(pageController.page, 0);
  });

  testWidgets(
      'click IconButton in bottom nav should moving to page 1 in pageView', (
      tester) async
  {
    final PageController pageController = PageController();
    await tester.pumpWidget(MaterialApp(home: Scaffold(
      bottomNavigationBar: BottomNav(pageController: pageController,),
      body: PageView(
        controller: pageController,
        children: [
          Container(),
          Container()
        ],
      ),
    ),
    ),
    );
    await tester.tap(find.widgetWithIcon(IconButton, Icons.bookmark));
    /// rebuild widget after the state has changed
    await tester.pumpAndSettle();

    expect(pageController.page, 1);
  });


}