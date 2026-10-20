import 'package:flutter/material.dart';
import 'package:pa_mobile/theme/app_colors.dart';

// Tombol filter kategori bergaya modern pill
class FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onPressed;

  const FilterChipButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: selected ? context.appPrimary : context.appSurfaceContainerHigh,
            borderRadius: BorderRadius.circular(30),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: context.appPrimary.withValues(alpha: 0.25),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : context.appTextSecondary,
            ),
          ),
        ),
      ),
    );
  }
}