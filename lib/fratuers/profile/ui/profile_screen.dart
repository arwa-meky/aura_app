import 'package:aura_project/core/helpers/extension.dart';
import 'package:aura_project/core/router/routes.dart';
import 'package:aura_project/core/widgets/custom_button.dart';
import 'package:aura_project/fratuers/profile/logic/logout_cubit.dart';
import 'package:aura_project/fratuers/profile/logic/logout_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LogoutCubit(),
      child: BlocConsumer<LogoutCubit, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            context.pushNamedAndRemoveAll(Routes.welcome);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text("Profile")),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //data
                  const SizedBox(height: 50),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: state is LogoutLoading
                        ? const CircularProgressIndicator()
                        : CustomButton(
                            text: "Logout",
                            onPressed: () {
                              context.read<LogoutCubit>().logout();
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
