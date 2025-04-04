// components/side_menu.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SideMenu extends StatefulWidget {
  final Function(int) onMenuItemSelected;
  
  const SideMenu({
    super.key, 
    required this.onMenuItemSelected,
  });
  
  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int selectedIndex = 0;
  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Songs', 'icon': CupertinoIcons.music_note},
    {'title': 'Playlist', 'icon': CupertinoIcons.list_bullet},
    {'title': 'Albums', 'icon': CupertinoIcons.book},
    {'title': 'Artists', 'icon': CupertinoIcons.person_2},
    {'title': 'Genres', 'icon': CupertinoIcons.music_note_list},
    {'title': 'Settings', 'icon': CupertinoIcons.settings},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 288,
      height: double.infinity,
      color: const Color.fromARGB(255, 52, 1, 114),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // User profile section
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white24,
              child: Icon(CupertinoIcons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 10),
            const Text(
              "User Name",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            const Text(
              "user@example.com",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 30),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 10),
            // Menu items
            Expanded(
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(
                      menuItems[index]['icon'],
                      color: selectedIndex == index ? Colors.white : Colors.white70,
                    ),
                    title: Text(
                      menuItems[index]['title'],
                      style: TextStyle(
                        color: selectedIndex == index ? Colors.white : Colors.white70,
                        fontWeight: selectedIndex == index ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: selectedIndex == index,
                    selectedTileColor: Colors.white.withOpacity(0.1),
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                      widget.onMenuItemSelected(index);
                      // Close drawer on mobile
                      if (Scaffold.of(context).isDrawerOpen) {
                        Navigator.pop(context);
                      }
                    },
                  );
                },
              ),
            ),
            // Bottom logout button
            const Divider(color: Colors.white24, thickness: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.white70),
              title: const Text(
                "Logout", 
                style: TextStyle(color: Colors.white70),
              ),
              onTap: () {
                // Add logout functionality here
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}