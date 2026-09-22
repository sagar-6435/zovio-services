import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ZovioSearchBar extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  final VoidCallback? onClearPressed;
  final Widget? prefixIcon;
  final bool autofocus;

  const ZovioSearchBar({
    super.key,
    this.hint = 'Search...',
    this.controller,
    this.onChanged,
    this.onSubmitted,
    this.onClearPressed,
    this.prefixIcon,
    this.autofocus = false,
  });

  @override
  State<ZovioSearchBar> createState() => _ZovioSearchBarState();
}

class _ZovioSearchBarState extends State<ZovioSearchBar> {
  late TextEditingController _controller;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_updateHasText);
  }

  void _updateHasText() {
    setState(() => _hasText = _controller.text.isNotEmpty);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    } else {
      _controller.removeListener(_updateHasText);
    }
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    widget.onClearPressed?.call();
    widget.onChanged?.call('');
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      autofocus: widget.autofocus,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      decoration: InputDecoration(
        hintText: widget.hint,
        prefixIcon: widget.prefixIcon ?? const Icon(Icons.search),
        suffixIcon: _hasText
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: _clear,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
