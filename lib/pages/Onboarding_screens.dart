import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:firebasechatapplatest/pages/introscreens/intropage1.dart';
import 'package:firebasechatapplatest/pages/introscreens/intropage2.dart';
import 'package:firebasechatapplatest/pages/introscreens/intropage3.dart';
import 'package:firebasechatapplatest/pages/register_page.dart';
import 'package:firebasechatapplatest/widgets/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreens extends StatefulWidget {
  const OnBoardingScreens({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreens> createState() => _OnBoardingScreensState();
}

class _OnBoardingScreensState extends State<OnBoardingScreens> {
  final LiquidController _liquidController = LiquidController();
  int _currentPage = 0;

  final List<Widget> _pages = [
    IntroPage1(),
    IntroPage2(),
    IntroPage3(),
  ];

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          LiquidSwipe(
            fullTransitionValue: 200,
            enableLoop: false,
            enableSideReveal: true,
            pages: _pages,
            liquidController: _liquidController,
            onPageChangeCallback: _onPageChanged,
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedSmoothIndicator(
                  activeIndex: _currentPage,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.white.withOpacity(0.5),
                    dotHeight: 8,
                    dotWidth: 8,
                    spacing: 10,
                  ),
                ),
                const SizedBox(height: 20),
                if (_currentPage == _pages.length - 1)
                  ElevatedButton(
                    onPressed: () {
                      nextScreen(context, RegisterPage());
                    },
                    child: const Text("Get Started"),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _liquidController.jumpToPage(page: _pages.length - 1);
                        },
                        child: const Text(
                          "Skip",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _liquidController.animateToPage(
                            page: _currentPage + 1,
                            duration: 500,
                          );
                        },
                        child: const Text("Next"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
