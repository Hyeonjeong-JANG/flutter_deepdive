import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:actual/restaurant/view/restaurant_screen.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  late TabController
      controller; // ?를 쓰면 controller를 쓸 때마다 null처리를 항상 해줘야 하는데 late를 쓰면 값을 부를 때 이 controller가 이미 선언이 되었다고 추정하고 오류를 내지 않는다.
  int index = 0;

  @override
  void initState() {
    super.initState();

    controller = TabController(
        length: 4,
        vsync:
            this); // vsync는 탭 컨트롤러를 사용하는 데 필요한 타이머 프로바이더. this는 현재 위젯의 상태를 참조하는 것. 여기에 this를 쓰려면 SingleTickerProviderStateMixin을 상속받아야 함. 애니메이션과 관련된 것을 쓰려면 이런 설정을 해야하는 경우가 제법 있다.
    controller.addListener(tabListener);
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);

    super.dispose();
  }

  // 탭을 누르면 탭바뷰가 변경되게 하기
  void tabListener() {
    setState(() {
      index = controller.index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '최고의 순대',
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: '홈'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood_outlined), label: '음식'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined), label: '주문'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: '프로필'),
        ],
      ),
      child: TabBarView(
        // 탭바뷰에서 스와이프해도 다른 탭으로 넘어가지 않아
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          RestaurantScreen(),
          Center(child: Container(color: Colors.white, child: Text('음식'))),
          Center(child: Container(color: Colors.white, child: Text('주문'))),
          Center(child: Container(color: Colors.white, child: Text('프로필'))),
        ],
      ),
    );
  }
}
