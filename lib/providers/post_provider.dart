import 'package:flutter/material.dart';
import '../models/post_model.dart';
import '../services/api_service.dart';
import 'user_provider.dart';

class PostProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<PostModel> _posts = [];
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  List<PostModel> get posts => _posts;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> fetchPosts(int userId) async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _posts = await _apiService.getPostsByUser(userId);
      _state = _posts.isEmpty ? ViewState.idle : ViewState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> addPost({required int userId, required String title, required String body}) async {
    final tempId = -DateTime.now().millisecondsSinceEpoch;
    final tempPost = PostModel(id: tempId, userId: userId, title: title, body: body, isPending: true);

    _posts.insert(0, tempPost);
    _state = ViewState.loaded;
    notifyListeners();

    try {
      final created = await _apiService.createPost(userId: userId, title: title, body: body);

      final index = _posts.indexWhere((p) => p.id == tempId);
      if (index != -1) {
        _posts[index] = PostModel(
          id: tempId,
          userId: created.userId,
          title: created.title,
          body: created.body,
          isPending: false,
        );
      }
      notifyListeners();
    } catch (e) {
      _posts.removeWhere((p) => p.id == tempId);
      notifyListeners();
      rethrow;
    }
  }

  Future<void> editPost(PostModel post, {required String title, required String body}) async {
    final index = _posts.indexWhere((p) => p.id == post.id);
    if (index == -1) return;

    final oldTitle = post.title;
    final oldBody = post.body;

    _posts[index].title = title;
    _posts[index].body = body;
    notifyListeners();

    try {
      await _apiService.updatePost(post);
    } catch (e) {
      _posts[index].title = oldTitle;
      _posts[index].body = oldBody;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> removePost(PostModel post) async {
    final index = _posts.indexOf(post);
    if (index == -1) return;

    _posts.removeAt(index);
    notifyListeners();

    try {
      await _apiService.deletePost(post.id);
    } catch (e) {
      _posts.insert(index, post);
      notifyListeners();
      rethrow;
    }
  }
}