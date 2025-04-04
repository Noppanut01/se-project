import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pocket_flow/common/util.dart';

class ApiService {
  // Base URL for your FastAPI backend
  final String url = baseUrl;

  // Sign Up API
  Future<Map<String, dynamic>> signUp(
      String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$url/sign_up/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(
          utf8.decode(response.bodyBytes)); // Return the response as a map
    } else {
      throw Exception('Failed to sign up');
    }
  }

  // Authenticate User API
  Future<Map<String, dynamic>> authenticateUser(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$url/auth/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(
          utf8.decode(response.bodyBytes)); // Return the response as a map
    } else {
      throw Exception('Authentication failed');
    }
  }

  // Update User API
  Future<Map<String, dynamic>> updateUser(int userId,
      {String? username, String? email, String? password}) async {
    final response = await http.put(
      Uri.parse('$url/update_user/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        if (username != null) 'username': username,
        if (email != null) 'email': email,
        if (password != null) 'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(
          utf8.decode(response.bodyBytes)); // Return the response as a map
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Delete User API
  Future<Map<String, dynamic>> deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('$url/delete_user/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(
          utf8.decode(response.bodyBytes)); // Return the response as a map
    } else {
      throw Exception('Failed to delete user');
    }
  }

  // Get All Users API
  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final response = await http.get(
      Uri.parse('$url/get_users/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      return responseData.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch all users');
    }
  }

  // Get User API
  Future<Map<String, dynamic>> getUser(int userId) async {
    final response = await http.get(
      Uri.parse('$url/get_user/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(
          utf8.decode(response.bodyBytes)); // Return the response as a map
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  // Add Transaction API
  Future<Map<String, dynamic>> addTransaction(
      double amount, String description, int categoryId, int userId) async {
    final response = await http.post(
      Uri.parse('$url/add_transaction/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': amount,
        'description': description,
        'category_id': categoryId,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(
          utf8.decode(response.bodyBytes)); // Return the response as a map
    } else {
      throw Exception('Failed to add transaction');
    }
  }

  // Get All Transactions API
  Future<List<Map<String, dynamic>>> getTransactions() async {
    final response = await http.get(
      Uri.parse('$url/get_transactions/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      return responseData.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch transactions');
    }
  }

  // Get Transactions by User API
  Future<List<Map<String, dynamic>>> getTransactionsByUser(int userId) async {
    final response = await http.get(
      Uri.parse('$url/get_transactions/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      return responseData.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch transactions for user');
    }
  }

  // Update Transaction API
  Future<Map<String, dynamic>> updateTransaction(int transactionId,
      double amount, String description, int categoryId, int userId) async {
    final response = await http.put(
      Uri.parse('$url/update_transaction/$transactionId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'amount': amount,
        'description': description,
        'category_id': categoryId,
        'user_id': userId,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(
          utf8.decode(response.bodyBytes)); // Return the response as a map
    } else {
      throw Exception('Failed to update transaction');
    }
  }

  // Get Categories API
  Future<List<Map<String, dynamic>>> getCategories() async {
    final response = await http.get(
      Uri.parse('$url/get_categories/'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      // Use utf8.decode to ensure proper decoding if needed
      List<dynamic> responseData = json.decode(utf8.decode(response.bodyBytes));
      return responseData.map((e) => e as Map<String, dynamic>).toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }

  Future<Map<String, dynamic>> getCategoryById(int categoryId) async {
    final response =
        await http.get(Uri.parse('$url/get_categories/$categoryId'));
    if (response.statusCode == 200) {
      return json.decode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to fetch category');
    }
  }

  // Delete Transaction API
  Future<Map<String, dynamic>> deleteTransaction(int transactionId) async {
    final response = await http.delete(
      Uri.parse('$url/delete_transaction/$transactionId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(
          utf8.decode(response.bodyBytes)); // Return the response as a map
    } else {
      throw Exception('Failed to delete transaction');
    }
  }

  // Get Total Expense API
  Future<double> getTotalExpense(int userId) async {
    final response = await http.get(
      Uri.parse('$url/total_expense/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData =
          json.decode(utf8.decode(response.bodyBytes));
      return (responseData['total_expense'] as num).toDouble();
    } else {
      throw Exception('Failed to fetch total expense');
    }
  }
}
