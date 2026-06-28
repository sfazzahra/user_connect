import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

enum ViewState { idle, loading, loaded, error }

class UserProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<UserModel> _users = [];
  ViewState _state = ViewState.idle;
  String _errorMessage = '';

  List<UserModel> get users => _users;
  ViewState get state => _state;
  String get errorMessage => _errorMessage;

  Future<void> fetchUsers() async {
    _state = ViewState.loading;
    notifyListeners();

    try {
      _users = await _apiService.getUsers();
      _state = _users.isEmpty ? ViewState.idle : ViewState.loaded;
    } catch (e) {
      _errorMessage = e.toString();
      _state = ViewState.error;
    }
    notifyListeners();
  }
}