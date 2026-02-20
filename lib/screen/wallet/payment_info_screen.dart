import 'package:flutter/material.dart';
import '../../helper/color.dart';
import '../../services/auth_service.dart';
import '../../services/wallet_service.dart';
import 'card_details_screen.dart';

class PaymentInfoScreen extends StatefulWidget {
  final double rechargeAmount;
  const PaymentInfoScreen({super.key, required this.rechargeAmount});

  @override
  State<PaymentInfoScreen> createState() => _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends State<PaymentInfoScreen> {
  final WalletService _walletService = WalletService();
  bool _isProcessing = false;
  String _selectedMethod = "GPAY";

  double get gst => widget.rechargeAmount * 0.18;
  double get total => widget.rechargeAmount + gst;

  Future<void> _handlePayment() async {
    if (_selectedMethod == "CARD") {
      final success = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              CardDetailsScreen(rechargeAmount: widget.rechargeAmount),
        ),
      );
      if (success == true) {
        // Already handled in CardDetailsScreen dialog, but we could do more here if needed
      }
      return;
    }

    setState(() => _isProcessing = true);

    // Simulate Payment Gateway Delay
    await Future.delayed(const Duration(seconds: 2));

    if (_selectedMethod == "RAZORPAY") {
      // Simulation for Razorpay integration
      debugPrint("Integrating Razorpay for amount: ${widget.rechargeAmount}");
    }

    final userId = AuthService.currentUserId ?? "test_user";
    final success = await _walletService.addMoney(
      userId,
      widget.rechargeAmount,
    );

    if (mounted) {
      setState(() => _isProcessing = false);
      if (success) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment failed. Please try again.")),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 64,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Payment Successful",
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              "₹${widget.rechargeAmount.toStringAsFixed(0)} has been added to your wallet.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Back to Payment Info
                  Navigator.pop(context); // Back to Add Money
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.goldAccent,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text(
                  "Done",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        title: Text(
          "Payment Information",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
        ),
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBillCard(isDark),
                  const SizedBox(height: 24),
                  _buildCouponInput(isDark),
                  const SizedBox(height: 12),
                  _buildBonusBanner(isDark),
                  const SizedBox(height: 32),
                  Text(
                    "Pay via UPI",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildUpiOptions(isDark),
                  const SizedBox(height: 32),
                  Text(
                    "Other",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isDark ? Colors.white : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildOtherOptions(isDark),
                ],
              ),
            ),
          ),
          _buildPayButton(isDark),
        ],
      ),
    );
  }

  Widget _buildBillCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          _billRow(
            "Recharge Amount",
            "₹${widget.rechargeAmount.toStringAsFixed(1)}",
            isDark,
          ),
          const SizedBox(height: 12),
          _billRow("GST @ 18%", "₹${gst.toStringAsFixed(1)}", isDark),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total Payable Amount",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                "₹${total.toStringAsFixed(1)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.verified_user, color: Colors.green, size: 16),
              const SizedBox(width: 8),
              Text(
                "Secured by Trusted Indian Banks",
                style: TextStyle(
                  color: AppColors.darkTextSecondary.withValues(alpha: 0.7),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _billRow(String label, String value, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: isDark
                ? Colors.white.withValues(alpha: 0.9)
                : AppColors.lightTextSecondary,
            fontWeight: FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            color: isDark ? Colors.white : AppColors.lightTextPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildCouponInput(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.lightTextPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: "Have a coupon code?",
                  hintStyle: TextStyle(
                    color: isDark
                        ? Colors.white38
                        : AppColors.lightTextSecondary.withValues(alpha: 0.5),
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            height: 48,
            width: 90,
            decoration: const BoxDecoration(
              color: AppColors.goldAccent,
              borderRadius: BorderRadius.horizontal(right: Radius.circular(12)),
            ),
            child: const Center(
              child: Text(
                "Apply",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBonusBanner(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF1C6),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.5,
            child: const Icon(
              Icons.card_giftcard,
              color: Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Bonus ₹25",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "₹75 balance in your wallet after recharge.",
                style: TextStyle(
                  color: isDark
                      ? Colors.brown.withValues(alpha: 0.7)
                      : Colors.brown,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUpiOptions(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              children: [
                Column(
                  children: [
                    _upiIconCircle(
                      Image.asset(
                        "lib/assets/icons/gpay_logo_custom.png",
                        height: 32,
                      ),
                      "GPAY",
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "GPay",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                Column(
                  children: [
                    _upiIconCircle(
                      Image.asset(
                        "lib/assets/icons/bhim_logo_custom.png",
                        height: 32,
                      ),
                      "BHIM",
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Bhim",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white
                            : AppColors.lightTextPrimary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: Colors.white12, height: 1),
          ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.08)
                    : AppColors.lightSection,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                "lib/assets/icons/bhim_logo_custom.png",
                height: 16,
                fit: BoxFit.contain,
              ),
            ),
            title: Text(
              "Pay with other UPI apps",
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: isDark ? Colors.white54 : AppColors.lightTextSecondary,
              size: 20,
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _upiIconCircle(Widget icon, String method) {
    bool isSelected = _selectedMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : AppColors.lightBackground,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: AppColors.goldAccent, width: 2)
              : Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.goldAccent.withValues(alpha: 0.3),
                    blurRadius: 8,
                  ),
                ]
              : null,
        ),
        child: Center(child: icon),
      ),
    );
  }

  Widget _buildOtherOptions(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          _otherOptionTile(
            Image.asset("lib/assets/icons/razorpay.png", height: 30),
            "Pay with Razorpay",
            "RAZORPAY",
            isDark,
          ),
          const Divider(color: Colors.white12, height: 1),
          _otherOptionTile(
            const Icon(Icons.credit_card, color: Colors.blue, size: 28),
            "Credit/Debit Card",
            "CARD",
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _otherOptionTile(
    Widget icon,
    String label,
    String method,
    bool isDark,
  ) {
    final isSelected = _selectedMethod == method;
    return InkWell(
      onTap: () => setState(() => _selectedMethod = method),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(child: icon),
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : AppColors.lightTextPrimary,
              ),
            ),
            const Spacer(),
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? AppColors.goldAccent
                      : (isDark ? Colors.white38 : Colors.grey.shade400),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: AppColors.goldAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayButton(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 30),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _handlePayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.goldAccent,
          foregroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          elevation: 0,
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: Colors.black,
                  strokeWidth: 3,
                ),
              )
            : const Text(
                "Pay Now",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
