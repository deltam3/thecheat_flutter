import 'package:flutter/material.dart';
import './posts/CommunityScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';

// void main() => runApp(MyApp());

Future main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '더치트',
      theme: ThemeData(
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(color: Colors.white),
        colorScheme: ColorScheme.light(
          primary: Colors.blue,
          secondary: Colors.white,
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
        ),
      ),
      home: AppLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AppLayout extends StatefulWidget {
  @override
  _AppLayoutState createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('검색', style: TextStyle(fontSize: 30))),
    Center(child: Text('채팅', style: TextStyle(fontSize: 30))),
    // Center(child: Text('커뮤니티', style: TextStyle(fontSize: 30))),
    CommunityScreen(),
    Center(child: Text('My', style: TextStyle(fontSize: 30))),
    Center(child: Text('헬프센터', style: TextStyle(fontSize: 30))),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text('더치트')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: '검색'),
          BottomNavigationBarItem(icon: Icon(Icons.textsms), label: '채팅'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'My'),
          BottomNavigationBarItem(icon: Icon(Icons.privacy_tip), label: '헬프센터'),
        ],
      ),
    );
  }
}
