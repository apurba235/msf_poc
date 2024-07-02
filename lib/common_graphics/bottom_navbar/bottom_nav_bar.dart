import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:msf/utils/color_consts.dart';


class BottomNavBarItem<T> {
  BottomNavBarItem({required this.value, required this.icon});

  final T value;
  final String icon;
}

class BottomNavBar<T> extends StatelessWidget {
  const BottomNavBar({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
  });

  final List<BottomNavBarItem<T>> items;
  final T selectedValue;
  final void Function(T value) onChanged;
  static const milliSeconds = 150;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColorConsts.white,
        boxShadow: [
          BoxShadow(color: AppColorConsts.black.withOpacity(0.16), spreadRadius: 1.0, blurRadius: 3.0),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          items.length,
              (index) {
            final bool isSelected = items[index].value == selectedValue;
            return Expanded(
              child: InkWell(
                onTap: () {
                  onChanged(items[index].value);
                  HapticFeedback.lightImpact();
                },
                child: UnconstrainedBox(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11.0),
                      color: isSelected ? AppColorConsts.lightDeepRed : AppColorConsts.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          items[index].icon,
                          height: 24,
                          width: 24,
                          color: isSelected ? AppColorConsts.white : index == 2 ? null : AppColorConsts.lightGrey,
                        ),
                        const SizedBox(height: 2),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
