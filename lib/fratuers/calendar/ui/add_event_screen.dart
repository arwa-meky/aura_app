import 'package:aura_project/fratuers/calendar/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  final EventModel? eventToEdit;
  const AddEventScreen({super.key, this.eventToEdit});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.eventToEdit != null) {
      _titleController.text = widget.eventToEdit!.title;
      _descController.text = widget.eventToEdit!.description;
      _dateController.text = DateFormat(
        'yyyy-MM-dd',
      ).format(widget.eventToEdit!.date);
      _timeController.text = widget.eventToEdit!.time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F8FF),
      appBar: AppBar(
        backgroundColor: const Color(0xffF5F8FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.eventToEdit == null ? "Add new Event" : "Edit Event",
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Event Title"),
            _buildTextField(
              hint: "Give it a name...",
              controller: _titleController,
            ),
            const SizedBox(height: 20),

            _buildLabel("Details"),
            _buildTextField(
              hint: "Add more details...",
              controller: _descController,
              maxLines: 5,
            ),
            const SizedBox(height: 20),

            _buildLabel("Date"),
            _buildTextField(
              hint: "Select date",
              controller: _dateController,
              icon: Icons.calendar_today,
              isReadOnly: true,
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: widget.eventToEdit?.date ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  _dateController.text = DateFormat(
                    'yyyy-MM-dd',
                  ).format(picked);
                }
              },
            ),
            const SizedBox(height: 20),

            _buildLabel("Time"),
            _buildTextField(
              hint: "Select Time",
              controller: _timeController,
              icon: Icons.access_time,
              isReadOnly: true,
              onTap: () async {
                TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  // ignore: use_build_context_synchronously
                  _timeController.text = picked.format(context);
                }
              },
            ),
            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _saveEvent,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E4F91),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  widget.eventToEdit == null ? "Save" : "Update Changes",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveEvent() {
    if (_dateController.text.isEmpty || _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select date and time")),
      );
      return;
    }

    final newEvent = EventModel(
      title: _titleController.text.isEmpty ? "No Title" : _titleController.text,
      description: _descController.text,
      date: DateTime.parse(_dateController.text),
      time: _timeController.text,
    );

    final box = Hive.box<EventModel>('events_box');
    if (widget.eventToEdit != null) {
      box.put(widget.eventToEdit!.key, newEvent);
    } else {
      box.add(newEvent);
    }
    Navigator.pop(context);
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
    ),
  );

  Widget _buildTextField({
    required String hint,
    required TextEditingController controller,
    int maxLines = 1,
    IconData? icon,
    bool isReadOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      readOnly: isReadOnly,
      onTap: onTap,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xff616161), fontSize: 13),
        suffixIcon: icon != null ? Icon(icon, color: Colors.grey) : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}
