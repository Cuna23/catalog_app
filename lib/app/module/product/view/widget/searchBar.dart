import 'package:flutter/material.dart';
import '../../../../common/utils/debouncer.dart';

class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final VoidCallback onFilterTap;

  const SearchBarWidget({
    super.key,
    required this.onChanged,
    required this.onFilterTap,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final _debouncer = Debouncer(milliseconds: 500);

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Wait until the user stops typing before firing the search.
                _debouncer.run(() => widget.onChanged(value));
              },
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: widget.onFilterTap,
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }
}