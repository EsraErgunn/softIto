import 'package:flutter/material.dart';
import '../../../../core/widgets/widgets.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Eşleşmelerim'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bekleyen'),
              Tab(text: 'Kabul Edilen'),
              Tab(text: 'Reddedilen'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: EmptyState.matches()),
            Center(child: EmptyState.matches()),
            Center(child: EmptyState.matches()),
          ],
        ),
      ),
    );
  }
}
