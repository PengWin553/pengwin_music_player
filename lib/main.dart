import 'package:flutter/material.dart';
import 'components/shared/widgets/navigation/side_menu.dart';
import 'components/features/songs/screens/songs.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.purple,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const Home(),
  ),
);

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;

  List<String> mainMenu = ['Songs', 'Playlist', 'Albums', 'Artists', 'Genres'];

  void _onMenuItemSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
    // You can add additional logic here based on the selected menu item
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 30, 1, 63),
            Color.fromARGB(255, 102, 10, 124),
          ],
        ),
      ),
      child: Scaffold(
        key: _scaffoldKey,
        // By default, Scaffold background is white
        // Set its value to transparent
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          leading: IconButton(
            // left icon
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu),
            color: Colors.white,
          ),
          // No title to keep the space next to the hamburger menu empty
          actions: [
            // right-aligned icons
            IconButton(
              onPressed: () {
                // Search functionality
              },
              icon: const Icon(Icons.search_sharp),
              color: Colors.white,
            ),
          ],
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
        ),
        drawer: Drawer(
          child: SideMenu(onMenuItemSelected: _onMenuItemSelected),
        ),
        body: Column(
          children: [
            // Menu row
            Row(
              children:
                  mainMenu.map((menuItem) {
                    int index = mainMenu.indexOf(menuItem);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _onMenuItemSelected(index),
                        child: Container(
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color:
                                    _currentIndex == index
                                        ? Colors.white
                                        : Colors.transparent,
                                width: 2.0,
                              ),
                            ),
                          ),
                          child: Text(
                            menuItem,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.00,
                              fontWeight:
                                  _currentIndex == index
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
            // Main content area
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: _buildContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    // This function returns different content based on the selected index
    switch (_currentIndex) {
      case 0:
        return Songs();
      case 1:
        return const Text(
          'Playlist Content',
          style: TextStyle(color: Colors.white, fontSize: 24),
        );
      case 2:
        return const Text(
          'Albums Content',
          style: TextStyle(color: Colors.white, fontSize: 24),
        );
      case 3:
        return const Text(
          'Artists Content',
          style: TextStyle(color: Colors.white, fontSize: 24),
        );
      case 4:
        return const Text(
          'Genres Content',
          style: TextStyle(color: Colors.white, fontSize: 24),
        );
      case 5:
        return const Text(
          'Equalizer',
          style: TextStyle(color: Colors.white, fontSize: 24),
        );
      case 6:
        return const Text(
          'Sleep Timer',
          style: TextStyle(color: Colors.white, fontSize: 24),
        );
      case 7:
        return const Text(
          'Settings',
          style: TextStyle(color: Colors.white, fontSize: 24),
        );
      default:
        return const Text(
          'Select an option',
          style: TextStyle(color: Colors.white, fontSize: 24),
        );
    }
  }
}
