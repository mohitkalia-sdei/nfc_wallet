import 'package:animation_wrappers/animations/faded_scale_animation.dart';
import 'package:flutter/material.dart';
import 'package:nfc_wallet/theme/colors.dart';

class AnimatedBottomBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Function? onBarTap;

  const AnimatedBottomBar({
    super.key,
    required this.barItems,
    this.onBarTap,
  });

  @override
  AnimatedBottomBarState createState() => AnimatedBottomBarState();
}

class AnimatedBottomBarState extends State<AnimatedBottomBar> with TickerProviderStateMixin {
  int selectedBarIndex = 0;
  Duration duration = const Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10.0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: _buildBarItems(),
        ),
      ),
    );
  }

  List<Widget> _buildBarItems() {
    List<Widget> barItems = [];
    for (int i = 0; i < widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isSelected = selectedBarIndex == i;
      barItems.add(InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          setState(() {
            selectedBarIndex = i;
            widget.onBarTap!(selectedBarIndex);
          });
        },
        child: AnimatedContainer(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          duration: duration,
          decoration: BoxDecoration(
            color: isSelected ? kMainColor.withOpacity(0.075) : Colors.transparent,
            borderRadius: const BorderRadius.all(
              Radius.circular(30),
            ),
          ),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: FadedScaleAnimation(
                  scaleDuration: const Duration(milliseconds: 500),
                  child: item.image,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              AnimatedSize(
                duration: duration,
                curve: Curves.easeInOut,
                child: Text(
                  isSelected ? item.text : '',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ));
    }
    return barItems;
  }
}

class BarItem {
  String text;
  Icon image;

  BarItem(
    this.text,
    this.image,
  );
}
