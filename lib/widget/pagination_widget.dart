import 'package:flutter/material.dart';

class PaginationWidget extends StatelessWidget {
  const PaginationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
