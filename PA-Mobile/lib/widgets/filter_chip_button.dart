import 'package:flutter/material.dart';
import 'package:pa_mobile/theme/app_colors.dart';

// Tombol pilihan filter (kategori, merek, urutan)
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
      padding: const EdgeInsets.only(right: 8),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: selected ? AppColors.red : AppColors.surface,
          foregroundColor: selected ? Colors.white : AppColors.textSecondary,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
            side: BorderSide(color: selected ? AppColors.red : AppColors.border),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}