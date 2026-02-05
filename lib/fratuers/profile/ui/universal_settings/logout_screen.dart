import 'package:aura_project/fratuers/profile/logic/profile_cubit.dart';
import 'package:flutter/material.dart';

void showLogoutDialog(BuildContext context, ProfileCubit cubit) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: const Color(0xffF8F9FD),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Log Out",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),

            const Text(
              "Are you sure you want to log out ?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Color(0xff616161),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                          color: Color(0xff194B96),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        foregroundColor: const Color(0xff194B96),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                          color: Color(0xff194B96),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 15),
                Expanded(
                  child: SizedBox(
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        cubit.logOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff194B96),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        "Yes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
