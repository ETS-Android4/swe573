import 'package:flutter/material.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/mockds/user.dart';
import 'package:funxchange/mockds/utils.dart';
import 'package:funxchange/screens/feed.dart';
import 'package:funxchange/screens/notification.dart';
import 'package:funxchange/screens/profile.dart';

void main() {
  MockUtils.populateData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: ContainerPage(),
    );
  }
}

class ContainerPage extends StatefulWidget {
  const ContainerPage({Key? key}) : super(key: key);

  @override
  State<ContainerPage> createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static final List<Widget> _widgetOptions = <Widget>[
    const FeedPage(),
    ProfilePage(
      userId: MockUserDataSource.currentUserId,
    ),
    const NotificationPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.feed),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: FunColor.fulvous,
        onTap: _onItemTapped,
      ),
    );
  }
}
