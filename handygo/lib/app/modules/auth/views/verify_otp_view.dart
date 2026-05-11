import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/auth/controllers/auth_controller.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';

class VerifyOtpView extends GetView<AuthController> {
  const VerifyOtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const CircularBackButton(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Verify Account",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      4,
                      (index) => Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[200]!),
                        ),
                        child: const Center(
                          child: Text(
                            "•", // Placeholder for digits
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't receive OTP? "),
                      Text(
                        "Re-send Code",
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: controller.verifyOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Verify",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          _buildNumericKeypad(),
        ],
      ),
    );
  }

  Widget _buildNumericKeypad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          _buildKeypadRow(["1", "2", "3"]),
          const SizedBox(height: 20),
          _buildKeypadRow(["4", "5", "6"]),
          const SizedBox(height: 20),
          _buildKeypadRow(["7", "8", "9"]),
          const SizedBox(height: 20),
          _buildKeypadRow(["*", "0", "backspace"]),
        ],
      ),
    );
  }

  Widget _buildKeypadRow(List<String> keys) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: keys.map((key) {
        if (key == "backspace") {
          return IconButton(
            onPressed: () {},
            icon: const Icon(Icons.backspace_outlined),
          );
        }
        return TextButton(
          onPressed: () {},
          child: Text(
            key,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
