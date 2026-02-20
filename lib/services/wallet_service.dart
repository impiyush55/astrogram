import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/wallet_model.dart';
import 'auth_service.dart';

class WalletService {
  final String baseUrl = "http://localhost:8080/api/wallet";

  /// Fetch user's wallet balance
  Future<double> fetchBalance(String userId) async {
    final url = Uri.parse("$baseUrl/balance/$userId");
    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final balance = (data['balance'] as num?)?.toDouble() ?? 0.0;
        AuthService.userWalletBalance = balance; // Sync with global session
        return balance;
      }
      return AuthService.userWalletBalance; // Fallback
    } catch (e) {
      debugPrint("Error fetching balance: $e");
      return AuthService.userWalletBalance;
    }
  }

  /// Fetch user's transaction history
  Future<List<WalletTransaction>> fetchTransactions(String userId) async {
    final url = Uri.parse("$baseUrl/transactions/$userId");
    try {
      final response = await http.get(url, headers: _getHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => WalletTransaction.fromJson(json)).toList();
      }
      return _generateDummyTransactions();
    } catch (e) {
      debugPrint("Error fetching transactions: $e");
      return _generateDummyTransactions();
    }
  }

  /// Add money to wallet
  Future<bool> addMoney(String userId, double amount) async {
    final url = Uri.parse("$baseUrl/add-money");
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({"userId": userId, "amount": amount}),
      );
      if (response.statusCode == 200) {
        await fetchBalance(userId); // Refresh balance
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error adding money: $e");
      return false;
    }
  }

  /// Deduct money from wallet (for sessions)
  Future<bool> deductMoney(String userId, double amount, String reason) async {
    final url = Uri.parse("$baseUrl/deduct-money");
    try {
      final response = await http.post(
        url,
        headers: _getHeaders(),
        body: jsonEncode({
          "userId": userId,
          "amount": amount,
          "description": reason,
        }),
      );
      if (response.statusCode == 200) {
        await fetchBalance(userId); // Refresh balance
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("Error deducting money: $e");
      return false;
    }
  }

  Map<String, String> _getHeaders() {
    Map<String, String> headers = {
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
    if (AuthService.currentUserToken != null) {
      headers["Authorization"] = "Bearer ${AuthService.currentUserToken}";
    }
    return headers;
  }

  List<WalletTransaction> _generateDummyTransactions() {
    return [
      WalletTransaction(
        id: "TXN101",
        type: "CREDIT",
        amount: 500.0,
        description: "Added to wallet via UPI",
        date: "30 Jan, 2026, 09:15 AM",
        status: "SUCCESS",
      ),
      WalletTransaction(
        id: "TXN102",
        type: "DEBIT",
        amount: 150.0,
        description: "Chat session with Pandit Krishna",
        date: "29 Jan, 2026, 04:30 PM",
        status: "SUCCESS",
      ),
      WalletTransaction(
        id: "TXN103",
        type: "DEBIT",
        amount: 200.0,
        description: "Kundli Matching Report",
        date: "28 Jan, 2026, 11:20 AM",
        status: "SUCCESS",
      ),
      WalletTransaction(
        id: "TXN104",
        type: "CREDIT",
        amount: 1000.0,
        description: "Promotion Bonus",
        date: "25 Jan, 2026, 10:00 AM",
        status: "SUCCESS",
      ),
    ];
  }
}
