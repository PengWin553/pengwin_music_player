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
    {'title': 'Equalizer', 'icon': CupertinoIcons.slider_horizontal_3},
    {'title': 'Sleep Timer', 'icon': CupertinoIcons.clock},
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
            // Logo image instead of CircleAvatar
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Penguin Music",
              style: TextStyle(
                color: Color.fromARGB(255, 255, 166, 33),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
           
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
                      color: Colors.white70,
                    ),
                    title: Text(
                      menuItems[index]['title'],
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    selected: false, // Remove selected state
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
          ],
        ),
      ),
    );
  }
}