import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_assignment/Controller/api_service.dart';
import 'package:test_assignment/View/Screens/favorite_list.dart';
import 'package:test_assignment/Model/user_model.dart';
import 'package:http/http.dart' as http;

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  final List<User> _users = [];
  int _currentPage = 1;
  bool _isLoading = true;
  bool _hasMoreData = true;
  final Set<int> _favoriteUserIds = {};

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    if (!_hasMoreData) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http
        .get(Uri.parse('${ApiService().baseURL}users?page=$_currentPage'));

    if (response.statusCode == 200) {
      final userResponse = UserResponse.fromJson(json.decode(response.body));

      setState(() {
        _currentPage++;
        _hasMoreData = userResponse.users.isNotEmpty;
        _users.addAll(userResponse.users);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  void _toggleFavorite(int userId) {
    setState(() {
      if (_favoriteUserIds.contains(userId)) {
        _favoriteUserIds.remove(userId);
      } else {
        _favoriteUserIds.add(userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(
                    favoriteUserIds: _favoriteUserIds,
                    allUsers: _users,
                  ),
                ),
              );
            },
          )
        ],
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent) {
            _fetchUsers();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: _users.length + 1,
          itemBuilder: (context, index) {
            if (index == _users.length) {
              return _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : const SizedBox();
            }
            final user = _users[index];
            return Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.avatar),
                ),
                title: Text('${user.firstName} ${user.lastName}'),
                subtitle: Text(user.email),
                trailing: IconButton(
                  icon: Icon(
                    _favoriteUserIds.contains(user.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _favoriteUserIds.contains(user.id) ? Colors.red : null,
                  ),
                  onPressed: () => _toggleFavorite(user.id),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
