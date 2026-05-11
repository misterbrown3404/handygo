import 'package:flutter/material.dart';

class CreditCardWidget extends StatelessWidget {
  final String cardNumber;
  final String cardHolder;
  final String expiryDate;

  const CreditCardWidget({
    super.key,
    required this.cardNumber,
    required this.cardHolder,
    required this.expiryDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D2D),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                cardNumber,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              // Mastercard logo dummy
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(-8, 0),
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.8),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Card Holder Name",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cardHolder,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Expiry Date",
                    style: TextStyle(color: Colors.grey, fontSize: 10),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expiryDate,
                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
