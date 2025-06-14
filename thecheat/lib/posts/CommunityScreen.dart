import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'post.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommunityScreen extends StatefulWidget {
  @override
  _CommunityScreenState createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<Post> _posts = [];
  bool _isLoading = true;
  String _error = '';

  final List<Map<String, String>> _categories = [
    {"category": "검거 소식", "description": "금융사기 용의자 검거 소식"},
    {"category": "사기 예방했어요", "description": "더치트 회원의 실제 사기 예방 사례"},
    {"category": "사건 사진자료", "description": "황당 사기피해 사진자료"},
    {"category": "사기뉴스 브리핑", "description": "매주 발행되는 알기쉬운 사기뉴스 브리핑"},
    {"category": "금융사기 관련 영상", "description": "금융사기 관련 유익한 영상"},
    {"category": "자유게시판", "description": "자유로운 소통 공간"},
    {"category": "고맙습니다! 캠페인", "description": "사이버 수사담당 경찰 응원 캠페인"},
    {"category": "신종 사기 주의/제보", "description": "신종 사기 주의/제보"},
    {"category": "사기 방지/검거 아이디어", "description": "사기 방지/검거 아이디어"},
    {"category": "피해자 공동대응 사이트", "description": "피해자 공동대응 사이트"},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchPosts();
  }

  // API에서 새글피드 가져오기
  Future<void> _fetchPosts() async {
    try {
      final apiUrl = dotenv.env['API_URL'] ?? 'http://localhost/api/v1';

      final response = await http.get(Uri.parse('$apiUrl/posts'));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final List<dynamic> data = decoded['posts']['data'];

        setState(() {
          _posts = data.map((item) => Post.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Failed to load data. Status: ${response.statusCode}.';
          _isLoading = false;
        });
        print('Error response body: ${response.body}');
      }
    } catch (e) {
      setState(() {
        _error = 'Error: $e';
        _isLoading = false;
      });
      print('Error details: $e');
    }
  }

  String _getCategoryById(int communityId) {
    if (communityId >= 1 && communityId <= _categories.length) {
      return _categories[communityId - 1]["category"]!;
    }
    return "";
  }

  String timeAgo(DateTime createdAt) {
    final currentTime = DateTime.now();
    final difference = currentTime.difference(createdAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return 'Just now';
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildPostsTab() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(child: Text(_error));
    }

    return ListView.builder(
      itemCount: _posts.length,
      itemBuilder: (context, index) {
        final post = _posts[index];
        String category = _getCategoryById(post.communityId);

        bool isNew = post.isNew();

        DateTime createdAt = DateTime.parse(post.createdAt);

        return Card(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      category,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 8),
                    if (isNew)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "N",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 8),
                // Post Content
                Text(post.content, style: TextStyle(fontSize: 16)),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      timeAgo(createdAt),
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(width: 16),
                    Icon(Icons.comment, size: 16, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(
                      '${post.commentsCount}',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCategoriesTab() {
    return ListView.builder(
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        final category = _categories[index];
        return Card(
          child: ListTile(
            title: Text(category['category']!),
            subtitle: Text(category['description']!),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('커뮤니티'),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight),
          child: Padding(
            padding: EdgeInsets.only(left: 0.0),
            child: TabBar(
              controller: _tabController,
              // isScrollable: true,
              tabs: [
                Tab(text: '새글피드'),
                Tab(text: '카테고리'),
              ],
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.black,
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildPostsTab(), _buildCategoriesTab()],
      ),
    );
  }
}
