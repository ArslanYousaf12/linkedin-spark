import 'package:flutter/material.dart';
import '../themes/app_theme.dart';

class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final bool isLoading;
  final bool fullWidth;
  final EdgeInsets? padding;
  final double? width;
  final double? height;
  final Widget? prefixIcon;
  final BorderRadius? borderRadius;

  const SecondaryButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = true,
    this.isLoading = false,
    this.fullWidth = true,
    this.padding,
    this.width,
    this.height,
    this.prefixIcon,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: fullWidth ? double.infinity : width,
      height: height,
      child:
          isOutlined
              ? OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8),
                  ),
                ),
                onPressed: isLoading ? null : onPressed,
                child: _buildChild(),
              )
              : TextButton(
                style: TextButton.styleFrom(
                  foregroundColor:
                      isDarkMode ? Colors.white : AppTheme.primaryColor,
                  padding: padding ?? const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: borderRadius ?? BorderRadius.circular(8),
                  ),
                ),
                onPressed: isLoading ? null : onPressed,
                child: _buildChild(),
              ),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(strokeWidth: 2.0),
      );
    }

    if (prefixIcon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          prefixIcon!,
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ],
      );
    }

    return Text(
      text,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }
}
