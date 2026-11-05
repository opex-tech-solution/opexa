import 'package:flutter/material.dart';
import '../../theme/widget.dart';

/// One tab in [AppBottomNavBar].
class AppNavItem {
  const AppNavItem({required this.label, required this.icon, this.selectedIcon});

  final String label;
  final IconData icon;

  /// Optional different icon when selected (defaults to [icon]).
  final IconData? selectedIcon;
}

/// Bottom navigation bar styled like the design: a lighter surface with a thin
/// top line, a soft grey pill behind the selected icon, a blue selected icon,
/// and a bold label for the selected tab.
///
/// All colours come from the current Theme (see Styles.themeData), so changing
/// the theme restyles the bar. It knows nothing about routing: it just reports
/// taps through [onSelected].
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.items,
    required this.currentIndex,
    required this.onSelected,
  });

  final List<AppNavItem> items;
  final int currentIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final barColor = theme.cardColor;
    final borderColor = theme.dividerColor;
    final colors = context.colors;

    return Material(
      color: barColor,
      child: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: borderColor)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              children: [
                for (var i = 0; i < items.length; i++)
                  Expanded(
                    child: _NavButton(
                      item: items[i],
                      selected: i == currentIndex,
                      iconColor: i == currentIndex ? colors.accent : colors.textSecondary,
                      labelColor: i == currentIndex
                          ? colors.textPrimary
                          : colors.textSecondary,
                      pillColor: colors.accentContainer,
                      onTap: () => onSelected(i),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.item,
    required this.selected,
    required this.iconColor,
    required this.labelColor,
    required this.pillColor,
    required this.onTap,
  });

  final AppNavItem item;
  final bool selected;
  final Color iconColor;
  final Color labelColor;
  final Color pillColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: item.label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        splashFactory: NoSplash.splashFactory,
        highlightColor: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              width: 58,
              height: 30,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? pillColor : Colors.transparent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                selected ? (item.selectedIcon ?? item.icon) : item.icon,
                size: 24,
                color: iconColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                height: 1.1,
                color: labelColor,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
