import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/audio/audio_bloc.dart';
import '../blocs/audio/audio_event.dart';
import '../blocs/theme/theme_bloc.dart';
import '../blocs/theme/theme_event.dart';
import '../widgets/home_tab.dart';
import '../widgets/meditation_tab.dart';
import '../widgets/profile_tab.dart';
import '../widgets/global_player.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: isDark
              ? const AssetImage('assets/bg2.jpeg')
              : const AssetImage('assets/bg1.jpeg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withValues(alpha: 0.2),
            BlendMode.darken,
          ),
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leadingWidth: 100,
          leading: Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Image.asset(
              isDark ? 'assets/langmai_2.png' : 'assets/langmai_1.png',
              fit: BoxFit.cover,
            ),
          ),
          title: Text(
            _currentIndex == 0
                ? 'Pháp Thoại Sư Ông'
                : _currentIndex == 1
                    ? 'Thiền tập'
                    : 'Thông tin',
          ),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              onPressed: () {
                context.read<ThemeBloc>().add(ToggleTheme());
              },
            ),
          ],
        ),
        body: IndexedStack(
          index: _currentIndex,
          children: [
            HomeTab(
              searchController: _searchController,
              searchFocusNode: _searchFocusNode,
            ),
            const MeditationTab(),
            const ProfileTab(),
          ],
        ),
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GlobalPlayer(),
            Container(
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.black.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.5),
                border: Border(
                  top: BorderSide(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1),
                  ),
                ),
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedItemColor: Theme.of(context).colorScheme.primary,
                unselectedItemColor: isDark ? Colors.white60 : Colors.black54,
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined),
                    activeIcon: Icon(Icons.home),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.self_improvement_outlined),
                    activeIcon: Icon(Icons.self_improvement),
                    label: '',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_outline),
                    activeIcon: Icon(Icons.person),
                    label: '',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
