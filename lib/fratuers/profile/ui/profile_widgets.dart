import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:flutter/material.dart';

Widget buildHeader(ProfileCubit cubit, String name, String email) {
  return Container(
    padding: const EdgeInsets.only(bottom: 30),
    decoration: const BoxDecoration(
      color: Color(0xff194B96),
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
    child: ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        backgroundImage: cubit.profileImage != null
            ? FileImage(cubit.profileImage!) as ImageProvider
            : null,
        child: cubit.profileImage == null
            ? const Icon(Icons.person, size: 50, color: Colors.grey)
            : null,
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(email, style: const TextStyle(color: Colors.white70)),
    ),
  );
}

Widget buildInfoCard(user) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        _row("Full Name", user.fullName),
        const Divider(),
        Row(
          children: [
            Expanded(child: _row("Gender", user.gender)),
            Expanded(child: _row("Age", "${user.age} years")),
          ],
        ),
        const Divider(),
        _row("Phone", user.phone),
        const Divider(),
        Row(
          children: [
            Expanded(child: _row("Height", "${user.height} cm")),
            Expanded(child: _row("Weight", "${user.weight} kg")),
          ],
        ),
      ],
    ),
  );
}

Widget _row(String title, String val) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      Text(val, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}

Widget buildTile(context, String title, IconData icon, VoidCallback onTap) {
  return Container(
    margin: const EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      leading: Icon(icon, color: const Color(0xff194B96)),
      title: Text(title),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    ),
  );
}

Widget field(String label, TextEditingController controller) {
  return TextField(
    controller: controller,
    decoration: InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.white,
    ),
  );
}
