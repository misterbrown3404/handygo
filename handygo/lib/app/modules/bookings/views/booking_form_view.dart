import 'package:handygo/app/core/constant/color.dart';
import 'package:handygo/app/modules/bookings/controllers/booking_flow_controller.dart';
import 'package:handygo/app/modules/auth/widgets/circular_back_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo/app/routes/app_pages.dart';  

import 'package:handygo/app/core/widgets/glass_container.dart';

class BookingFormView extends GetView<BookingFlowController> {
  const BookingFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF3F4F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const CircularBackButton(),
        title: Text(
          "Booking Form",
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE0EAFC),
              Color(0xFFCFDEF3),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputField("Name", "Enter name", controller.nameController),
                const SizedBox(height: 24),
                _buildInputField("Email Address", "Enter email address", controller.emailController),
                const SizedBox(height: 24),
                _buildDatePickerField(context, "Date", "Select date", controller.dateController),
                const SizedBox(height: 24),
                _buildTimePickerField(context, "Time", "Select time", controller.timeController),
                const SizedBox(height: 24),
                _buildNoteField("Additional Note", "Add note", controller.notesController),
                const SizedBox(height: 48),
                _buildContinueButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(String label, String hint, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: textController,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField(BuildContext context, String label, String hint, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: DateTime.now().add(const Duration(days: 1)),
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (date != null) {
              textController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
            }
          },
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.5),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      textController.text.isEmpty ? hint : textController.text,
                      style: TextStyle(color: textController.text.isEmpty ? Colors.grey[400] : Colors.black),
                    )),
                Icon(Icons.calendar_month_outlined, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimePickerField(BuildContext context, String label, String hint, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            final time = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (time != null) {
              textController.text = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
            }
          },
          child: GlassContainer(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.5),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Obx(() => Text(
                      textController.text.isEmpty ? hint : textController.text,
                      style: TextStyle(color: textController.text.isEmpty ? Colors.grey[400] : Colors.black),
                    )),
                Icon(Icons.access_time, color: Colors.grey[400], size: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteField(String label, String hint, TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: textController,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            filled: true,
            fillColor: Colors.white.withOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.white.withOpacity(0.2)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContinueButton() {
    return ElevatedButton(
      onPressed: () {
        if (controller.dateController.text.isEmpty || controller.timeController.text.isEmpty) {
          Get.snackbar("Required", "Please select date and time", backgroundColor: Colors.orangeAccent);
          return;
        }
        Get.toNamed(Routes.SELECT_ROOMS);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        minimumSize: const Size(double.infinity, 56),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 0,
      ),
      child: const Text(
        "Continue",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }
}
