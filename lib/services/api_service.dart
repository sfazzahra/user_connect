import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/post_model.dart';

class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<UserModel>> getUsers() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/users'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw ApiException('Server merespon dengan status ${response.statusCode}');
      }
    } on http.ClientException {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    } catch (e) {
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<List<PostModel>> getPostsByUser(int userId) async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/posts?userId=$userId'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => PostModel.fromJson(json)).toList();
      } else {
        throw ApiException('Gagal mengambil postingan (status ${response.statusCode})');
      }
    } on http.ClientException {
      throw ApiException('Tidak bisa terhubung ke server. Cek koneksi internet Anda.');
    } catch (e) {
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<PostModel> createPost({required int userId, required String title, required String body}) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/posts'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode({'userId': userId, 'title': title, 'body': body}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        return PostModel.fromJson(json);
      } else {
        throw ApiException('Gagal menambah postingan (status ${response.statusCode})');
      }
    } on http.ClientException {
      throw ApiException('Tidak bisa terhubung ke server saat menyimpan postingan.');
    } catch (e) {
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<PostModel> updatePost(PostModel post) async {
    try {
      final response = await http
          .put(
            Uri.parse('$_baseUrl/posts/${post.id}'),
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(post.toJson()),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return PostModel.fromJson(json);
      } else {
        throw ApiException('Gagal mengubah postingan (status ${response.statusCode})');
      }
    } on http.ClientException {
      throw ApiException('Tidak bisa terhubung ke server saat mengubah postingan.');
    } catch (e) {
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }

  Future<void> deletePost(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_baseUrl/posts/$id'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw ApiException('Gagal menghapus postingan (status ${response.statusCode})');
      }
    } on http.ClientException {
      throw ApiException('Tidak bisa terhubung ke server saat menghapus postingan.');
    } catch (e) {
      throw ApiException('Terjadi kesalahan: ${e.toString()}');
    }
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}