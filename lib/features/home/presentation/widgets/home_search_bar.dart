import 'package:flutter/material.dart';

/// Tappable search bar. Navigates to SearchPage on tap (not yet implemented).
class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () {
          // TODO: navigate to SearchPage
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Search coming soon'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: const Color(0xFFE8EAE9)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: const Row(
            children: [
              Icon(Icons.search, color: Color(0xFF79747E), size: 18),
              SizedBox(width: 10),
              Text(
                'Cari shalawat, bait, atau kitab...',
                style: TextStyle(fontSize: 14, color: Color(0xFF79747E)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
