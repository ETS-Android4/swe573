import 'package:flutter/material.dart';
import 'package:funxchange/framework/api/funxchange_api.dart';
import 'package:funxchange/framework/colors.dart';
import 'package:funxchange/framework/di.dart';
import 'package:funxchange/screens/feed.dart';
import 'package:funxchange/screens/notification.dart';
import 'package:funxchange/screens/profile.dart';
import 'package:funxchange/screens/welcome.dart';

void main() {
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
  _ContainerPageState createState() => _ContainerPageState();
}

class _ContainerPageState extends State<ContainerPage> {
  bool _isAuthenticated = false;

  @override
  void initState() {
    FunxchangeApiDataSource.singleton.onAuthStatusChanged = (status) {
      setState(() {
        _isAuthenticated = status != null;
      });
    };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return const LoggedInPage();
    }
    return WelcomePage(
      onAuth: (response) async {
        await FunxchangeApiDataSource.singleton
            .addAuthToken(response[0], response[1]);
      },
    );
  }
}

class LoggedInPage extends StatefulWidget {
  const LoggedInPage({Key? key}) : super(key: key);

  @override
  State<LoggedInPage> createState() => _LoggedInPageState();
}

class _LoggedInPageState extends State<LoggedInPage> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: [
          const FeedPage(),
          ProfilePage(
            userId: DIContainer.activeSingleton.userRepo.getCurrentUserId(),
          ),
          const NotificationPage()
        ].elementAt(_selectedIndex),
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
