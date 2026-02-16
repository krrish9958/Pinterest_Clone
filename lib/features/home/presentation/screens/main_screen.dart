import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:pinterest_clone/features/search/search_screen.dart';
import 'package:pinterest_clone/home/presentation/home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 0;

  final _screens = const [
    HomeScreen(),
    SearchScreen(),
    _SimpleCenterScreen(title: 'Create Pin', icon: Icons.add_photo_alternate_outlined),
    _SimpleCenterScreen(title: 'Messages', icon: Icons.chat_bubble_outline_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(12, 0, 12, 6),
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavIcon(
                icon: CupertinoIcons.house,
                selectedIcon: CupertinoIcons.house_fill,
                selected: _index == 0,
                onTap: () => setState(() => _index = 0),
              ),
              _NavIcon(
                icon: CupertinoIcons.search,
                selectedIcon: CupertinoIcons.search,
                selected: _index == 1,
                onTap: () => setState(() => _index = 1),
              ),
              _NavIcon(
                icon: CupertinoIcons.add,
                selectedIcon: CupertinoIcons.add,
                selected: _index == 2,
                onTap: () => setState(() => _index = 2),
              ),
              _NavIcon(
                icon: CupertinoIcons.chat_bubble,
                selectedIcon: CupertinoIcons.chat_bubble_fill,
                selected: _index == 3,
                onTap: () => setState(() => _index = 3),
              ),
              _NavIcon(
                icon: CupertinoIcons.person_crop_circle,
                selectedIcon: CupertinoIcons.person_crop_circle_fill,
                selected: false,
                onTap: _showProfileSheet,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showProfileSheet() async {
    final authState = ClerkAuth.of(context, listen: false);
    final user = authState.user;
    final name = [
      user?.firstName,
      user?.lastName,
    ].whereType<String>().where((v) => v.trim().isNotEmpty).join(' ');
    final email = user?.email ?? '';

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: false,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.antiAlias,
      builder: (sheetContext) {
        return Material(
          color: Colors.white,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 34,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD6D6D6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Profile',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  if (name.isNotEmpty) Text(name),
                  if (email.isNotEmpty) Text(email),
                  const SizedBox(height: 14),
                  const Divider(height: 1, color: Color(0xFFE9E9E9)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        final shouldLogout = await showDialog<bool>(
                          context: sheetContext,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Log out?'),
                              content: const Text(
                                'Are you sure you want to log out?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text('Log out'),
                                ),
                              ],
                            );
                          },
                        );

                        if (shouldLogout == true) {
                          if (!sheetContext.mounted) return;
                          Navigator.of(sheetContext).pop();
                          await authState.signOut();
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SimpleCenterScreen extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SimpleCenterScreen({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 46, color: Colors.black45),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final bool selected;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.selectedIcon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(
          selected ? selectedIcon : icon,
          color: selected ? Colors.black : Colors.black87,
          size: 25,
        ),
      ),
    );
  }
}
