import 'package:flutter/material.dart';
import 'package:test_assignment/Model/user_model.dart';

class FavoritesScreen extends StatelessWidget {
  final Set<int> favoriteUserIds;
  final List<User> allUsers;

  const FavoritesScreen(
      {super.key, required this.favoriteUserIds, required this.allUsers});

  @override
  Widget build(BuildContext context) {
    final favoriteUsers =
        allUsers.where((user) => favoriteUserIds.contains(user.id)).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: ListView.builder(
        itemCount: favoriteUsers.length,
        itemBuilder: (context, index) {
          final user = favoriteUsers[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user.avatar),
              ),
              title: Text('${user.firstName} ${user.lastName}'),
              subtitle: Text(user.email),
            ),
          );
        },
      ),
    );
  }
}
