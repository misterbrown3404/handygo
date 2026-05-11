import 'package:flutter/material.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:handygo/app/modules/payment/widgets/credit_card_widget.dart';

class AddCardView extends StatelessWidget {
  const AddCardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Add Card",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CreditCardWidget(
              cardNumber: "3659 **** **** 6971",
              cardHolder: "John Leam",
              expiryDate: "30/03/27",
            ),
            const SizedBox(height: 32),
            _buildInputField("Card Holder Name", "Enter name"),
            const SizedBox(height: 24),
            _buildInputField("Card Number", "Enter card number"),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(child: _buildInputField("Expiry Date", "Select date", icon: Icons.calendar_today_outlined)),
                const SizedBox(width: 16),
                Expanded(child: _buildInputField("CVV", "Enter CVV")),
              ],
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Checkbox(
                  value: true,
                  onChanged: (val) {},
                  activeColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                ),
                const Text(
                  "I agree to the ",
                  style: TextStyle(fontSize: 12),
                ),
                const Text(
                  "Terms and Conditions",
                  style: TextStyle(fontSize: 12, color: AppColors.primaryColor, decoration: TextDecoration.underline),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                minimumSize: const Size(double.infinity, 56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Add Card",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
            suffixIcon: icon != null ? Icon(icon, color: Colors.grey[400], size: 20) : null,
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
