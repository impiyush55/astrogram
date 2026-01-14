class AuthService {
  // TODO: Replace with your actual base URL
  final String baseUrl = "http://localhost:8080/auth";

  /// Send OTP to the given phone number
  /// Returns token or session ID if needed, or simply true/false for success.
  Future<bool> sendOtp(String phoneNumber) async {
    // DUMMY IMPLEMENTATION
    await Future.delayed(const Duration(seconds: 2));
    print("Dummy OTP sent to $phoneNumber");
    return true;

    /* REVERT TO THIS WHEN API IS READY
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
        print("Failed to send OTP: ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error sending OTP: $e");
      return false;
    }
    */
  }

  /// Verify OTP
  /// Returns the auth token or user object on success
  Future<Map<String, dynamic>?> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    // DUMMY IMPLEMENTATION
    await Future.delayed(const Duration(seconds: 2));
    if (otp == "123456") {
      return {
        "token": "dummy_token_123",
        "user": {"id": 1, "mobile": phoneNumber, "name": "Dummy User"},
      };
    } else {
      // For testing, let's accept any OTP or just 123456
      // return null if we want to simulate failure
      // For now, accept everything for ease:
      return {
        "token": "dummy_token_123",
        "user": {"id": 1, "mobile": phoneNumber, "name": "Dummy User"},
      };
    }

    /* REVERT TO THIS WHEN API IS READY
    final url = Uri.parse("$baseUrl/verify-otp");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"mobile": phoneNumber, "otp": otp}),
      );

      if (response.statusCode == 200) {
        // Return user data/token
        return jsonDecode(response.body);
      } else {
        print("Invalid OTP: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error verifying OTP: $e");
      return null;
    }
    */
  }
}
