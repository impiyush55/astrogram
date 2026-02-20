import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AuthService {
  // Global session state (Temporary replacement for SharedPreferences)
  static String? currentUserId;
  static String? currentUserToken;
  static String? userPhone;
  static Map<String, dynamic>? currentUserProfile;

  // Wallet and other session data
  static double userWalletBalance = 0.0;

  /// Centralized method to update session after login or profile fetch
  static void updateSession({
    String? userId,
    String? token,
    String? phone,
    Map<String, dynamic>? profile,
  }) {
    if (userId != null) currentUserId = userId;
    if (token != null) currentUserToken = token;
    if (phone != null) userPhone = phone;
    if (profile != null) {
      currentUserProfile = profile;
      // Also update individual fields if they exist in profile
      if (profile.containsKey('fullName')) {
        // Optional: you could keep AuthService.userName but it's better to use currentUserProfile['fullName']
      }
    }
    debugPrint(
      "Session Updated: ID=$currentUserId, Phone=$userPhone, Token=${currentUserToken != null ? 'Present' : 'Missing'}",
    );
  }

  // TODO: Replace with your actual base URL
  final String baseUrl = "http://localhost:8080/auth";

  /// Send OTP to the given phone number
  /// Returns token or session ID if needed, or simply true/false for success.
  Future<bool> sendOtp(String phoneNumber) async {
    final url = Uri.parse("$baseUrl/send-otp");

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          // "Authorization": "Bearer if_needed",
        },
        body: jsonEncode({"mobile": phoneNumber}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Parse success response
        // final data = jsonDecode(response.body);
        return true;
      } else {
        // Handle server errors
        debugPrint("Failed to send OTP: ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error sending OTP: $e");
      return false;
    }
  }

  /// Verify OTP
  /// Returns the auth token or user object on success
  Future<Map<String, dynamic>?> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    final url = Uri.parse("$baseUrl/verify-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile": phoneNumber, "otp": otp}),
      );
      debugPrint("Status Code: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final body = response.body.trim();
        // Try to decode JSON, but fallback to treating body as a token if it fails
        try {
          final decoded = jsonDecode(body);
          if (decoded is Map<String, dynamic>) {
            return decoded;
          } else {
            // It was valid JSON (like a quoted string), but not a Map
            return {"token": decoded.toString(), "userId": phoneNumber};
          }
        } catch (e) {
          // Identify if response is a raw string (e.g. UUID)
          // Just wrap it in a Map. Use phone as fallback ID if no ID provided.
          return {"token": body, "id": body, "userId": phoneNumber};
        }
      } else {
        debugPrint("Invalid OTP or Server Error");
        return null;
      }
    } catch (e) {
      debugPrint("Error verifying OTP: $e");
      return null;
    }
  }

  /// Save User Details (Create new profile)
  /// POST /api/user-details/save
  Future<Map<String, dynamic>?> saveUserDetails({
    required String fullName,
    required String email,
    required String phone,
    required String gender,
    required String dateOfBirth,
    required String timeOfBirth,
    required String placeOfBirth,
    required String currentAddress,
    required String cityStateCountry,
    required String pincode,
  }) async {
    final url = Uri.parse("http://localhost:8080/api/user-details/save");

    try {
      debugPrint("Saving user details for: $phone");

      final body = jsonEncode({
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "timeOfBirth": timeOfBirth,
        "placeOfBirth": placeOfBirth,
        "currentAddress": currentAddress,
        "cityStateCountry": cityStateCountry,
        "pincode": pincode,
      });

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      if (currentUserToken != null &&
          currentUserToken != "null" &&
          currentUserToken!.isNotEmpty) {
        headers["Authorization"] = "Bearer $currentUserToken";
      }

      final response = await http.post(url, headers: headers, body: body);

      debugPrint("Save User Details Response: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint("User details saved successfully: $data");

        // Update global session with new profile data
        updateSession(
          userId: data['id']?.toString(),
          phone: phone,
          profile: data,
        );

        return data;
      } else {
        debugPrint("Failed to save user details: ${response.body}");
        return {"error": true, "message": response.body};
      }
    } catch (e) {
      debugPrint("Error saving user details: $e");
      return null;
    }
  }

  /// Update User Details
  /// PUT /api/user-details/update/{phone}
  Future<Map<String, dynamic>?> updateUserDetails({
    required String phone,
    required String fullName,
    required String email,
    required String gender,
    required String dateOfBirth,
    required String timeOfBirth,
    required String placeOfBirth,
    required String currentAddress,
    required String cityStateCountry,
    required String pincode,
  }) async {
    final cleanPhone = phone.trim();
    final url = Uri.parse(
      "http://localhost:8080/api/user-details/update/$cleanPhone",
    );

    try {
      debugPrint("Updating user details for: $cleanPhone");

      final body = jsonEncode({
        "fullName": fullName,
        "email": email,
        "phone": phone,
        "gender": gender,
        "dateOfBirth": dateOfBirth,
        "timeOfBirth": timeOfBirth,
        "placeOfBirth": placeOfBirth,
        "currentAddress": currentAddress,
        "cityStateCountry": cityStateCountry,
        "pincode": pincode,
      });

      Map<String, String> headers = {
        "Content-Type": "application/json",
        "Accept": "application/json",
      };
      if (currentUserToken != null &&
          currentUserToken != "null" &&
          currentUserToken!.isNotEmpty) {
        headers["Authorization"] = "Bearer $currentUserToken";
      }

      final response = await http.put(url, headers: headers, body: body);

      debugPrint("Update User Details Response: ${response.statusCode}");
      debugPrint("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("User details updated successfully: $data");

        // Update global session with updated profile data
        updateSession(
          userId: data['id']?.toString(),
          phone: cleanPhone,
          profile: data,
        );

        return data;
      } else {
        debugPrint("Failed to update user details: ${response.body}");
        return {"error": true, "message": response.body};
      }
    } catch (e) {
      debugPrint("Error updating user details: $e");
      return null;
    }
  }

  /// Logout user and clear session
  /// POST /auth/logout
  Future<bool> logout() async {
    final url = Uri.parse("$baseUrl/logout");

    try {
      debugPrint("Logging out user...");

      Map<String, String> headers = {"Content-Type": "application/json"};
      if (currentUserToken != null &&
          currentUserToken != "null" &&
          currentUserToken!.isNotEmpty) {
        headers["X-SESSION-TOKEN"] = currentUserToken!;
      }

      final response = await http.post(url, headers: headers);

      debugPrint("Logout Response: ${response.statusCode}");

      // Clear session data regardless of response (client-side logout)
      currentUserId = null;
      currentUserToken = null;
      userPhone = null;
      currentUserProfile = null;
      userWalletBalance = 0.0;

      debugPrint("Session cleared successfully");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      debugPrint("Error during logout: $e");
      // Still clear session on error
      currentUserId = null;
      currentUserToken = null;
      userPhone = null;
      currentUserProfile = null;
      userWalletBalance = 0.0;
      return false;
    }
  }

  /// Fetch User Profile Details
  Future<Map<String, dynamic>?> fetchUserProfile([String? phone]) async {
    // 1. Use provided phone, 2. Use session phone, 3. Use test fallback
    final searchPhone = (phone != null && phone.isNotEmpty)
        ? phone
        : (userPhone != null && userPhone!.isNotEmpty)
        ? userPhone!
        : "9876543210";

    final cleanPhone = searchPhone.trim();
    if (cleanPhone.isEmpty) return null;

    final url = Uri.parse(
      "http://localhost:8080/api/user-details/by-phone/$cleanPhone",
    );

    try {
      debugPrint("Fetching profile from: $url");

      Map<String, String> headers = {"Accept": "application/json"};
      if (currentUserToken != null &&
          currentUserToken != "null" &&
          currentUserToken!.isNotEmpty) {
        headers["Authorization"] = "Bearer $currentUserToken";
      }

      final response = await http
          .get(url, headers: headers)
          .timeout(const Duration(seconds: 10));

      debugPrint("Profile Response Status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        debugPrint("Profile Data Found: $data");

        // Update global session with profile data
        updateSession(
          userId: data['id']?.toString(),
          phone: data['phone']?.toString() ?? cleanPhone,
          profile: data,
        );

        return data;
      } else if (response.statusCode == 500 || response.statusCode == 404) {
        debugPrint("Profile Not Found or Server Error: ${response.statusCode}");
        // Return a map with a null profile indicate it was checked but not found
        return {"notFound": true, "status": response.statusCode};
      } else {
        debugPrint("Profile Fetch Failed: ${response.statusCode}");
        return {"error": true, "status": response.statusCode};
      }
    } catch (e) {
      debugPrint("Error fetching profile: $e");
      return null;
    }
  }
}
