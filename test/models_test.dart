import 'package:flutter_test/flutter_test.dart';
import 'package:fuertes_advmobprog_longexam1/models/comment.dart';
import 'package:fuertes_advmobprog_longexam1/models/post.dart';
import 'package:fuertes_advmobprog_longexam1/models/user.dart';
import 'package:fuertes_advmobprog_longexam1/services/user_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('Post reads nested reactions and falls back to flat likes', () {
    final nested = Post.fromJson({
      'id': 1,
      'title': 'His mother had always taught him',
      'body': '...',
      'userId': 121,
      'reactions': {'likes': 192, 'dislikes': 25},
    });
    expect(nested.likes, 192);
    expect(nested.dislikes, 25);
    expect(nested.userId, 121);
    expect(nested.toJson()['reactions'], {'likes': 192, 'dislikes': 25});

    final flat = Post.fromJson({'id': 2, 'likes': 7});
    expect(flat.likes, 7);
    expect(flat.title, '');
  });

  test('Comment reads the nested user', () {
    final comment = Comment.fromJson({
      'id': 93,
      'body': 'These are fabulous ideas!',
      'postId': 1,
      'likes': 7,
      'user': {'id': 190, 'username': 'leahw', 'fullName': 'Leah Gutierrez'},
    });
    expect(comment.userId, 190);
    expect(comment.username, 'leahw');
    expect(comment.fullName, 'Leah Gutierrez');

    // POST /comments/add answers without a likes field.
    expect(Comment.fromJson({'id': 341, 'body': 'hi', 'postId': 1}).likes, 0);
  });

  test(
    'UserService saves and reads the user back through preferences',
    () async {
      SharedPreferences.setMockInitialValues({});
      final service = UserService();

      expect(await service.isLoggedIn(), isFalse);

      await service.saveUserData(
        User.fromJson({
          'id': 1,
          'username': 'emilys',
          'firstName': 'Emily',
          'lastName': 'Johnson',
          'image': 'https://dummyjson.com/icon/emilys/128',
          'accessToken': 'abc',
        }),
      );

      expect(await service.isLoggedIn(), isTrue);
      final user = await service.getUser();
      expect(user.fullName, 'Emily Johnson');
      expect(user.id, 1);

      await service.logout();
      expect(await service.isLoggedIn(), isFalse);
    },
  );
}
