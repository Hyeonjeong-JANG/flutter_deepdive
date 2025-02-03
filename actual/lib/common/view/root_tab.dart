import 'package:actual/common/const/colors.dart';
import 'package:actual/common/layout/default_layout.dart';
import 'package:flutter/material.dart';

class RootTab extends StatefulWidget {
  const RootTab({super.key});

  @override
  State<RootTab> createState() => _RootTabState();
}

class _RootTabState extends State<RootTab> with SingleTickerProviderStateMixin {
  // TabController를 사용하기 위해서는 vsync에 this를 넣어줘야 하는데 그 this를 넣어주기 위해서는 with SingleTickerProviderStateMixin을 해줘야 한다. 그래야 this에 에러가 나지 않는다.
  late TabController
      controller; // late의 의미: late가 붙은 애는 나중에 불러올 때는 반드시 선언이 되어 있을 것이라는 의미이다. TabController는 initState에서 반드시 선언이 되어 있을 거야.

  int index = 0;

  @override
  void initState() { // initState()에서 addListener()를 통해 tabListener를 등록 → 탭 변경 시 setState() 호출하여 UI 갱신
    super.initState();

    controller = TabController(length: 4, vsync: this); // 이건 현재 class이다.

    controller.addListener(tabListener);
  }

  @override
  void dispose() { // dispose()에서 removeListener()를 호출하여 불필요한 리스너를 제거하고 메모리 누수를 방지
    controller.removeListener(tabListener);

    super.dispose();
  }

  void tabListener() {
    setState(() {
      index = controller
          .index; // 컨트롤러의 인덱스를 인덱스에 넣어주겠다. 그리고 바뀔 때마다 setState를 실행하겠다.
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '코팩 딜리버리',
      child: TabBarView(
        physics: NeverScrollableScrollPhysics(), // 탭바뷰에서 스와이프해도 이동하지 않는다.
        controller: controller,
        children: [
          Center(child: Container(child: Text('홈'))),
          Center(child: Container(child: Text('음식'))),
          Center(child: Container(child: Text('주문'))),
          Center(child: Container(child: Text('프로필'))),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: PRIMARY_COLOR,
        unselectedItemColor: BODY_TEXT_COLOR,
        selectedFontSize: 10.0,
        unselectedFontSize: 10.0,
        type: BottomNavigationBarType.fixed,
        // 선택된 탭이 크게 보임
        onTap: (int index) {
          // setState(() {
          //   this.index = index; // 클릭할 때마다 선택된 인덱스를 저장하겠다.
          // });

          // 셋스테이트를 할 필요 없이 animateTo를 하면 바텀내비게이션이랑 탭바뷰랑 연동이 잘 된다.
          controller.animateTo(index);
        },
        currentIndex: index,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '홈',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fastfood_outlined),
            label: '음식',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            label: '주문',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: '프로필',
          ),
        ],
      ),
    );
  }
}
