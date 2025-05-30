import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhir_praktpm/presenters/user_presenter.dart';
import 'package:projekakhir_praktpm/utils/constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserPresenter>(
      builder: (context, userPresenter, child) {
        final currentUser = userPresenter.currentUser;

        if (currentUser == null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.mediumPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off_outlined, size: 80, color: AppColors.hintColor),
                  const SizedBox(height: AppPadding.mediumPadding),
                  Text(
                    'Anda belum login.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: AppColors.secondaryTextColor),
                  ),
                  const SizedBox(height: AppPadding.smallPadding),
                  Text(
                    'Login untuk melihat profil Anda.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.hintColor),
                  ),
                  const SizedBox(height: AppPadding.mediumPadding),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text('Login Sekarang'),
                  ),
                ],
              ),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(AppPadding.mediumPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppPadding.largePadding),
              CircleAvatar(
                radius: 60,
                backgroundColor: AppColors.accentColor,
                child: Text(
                  currentUser.username[0].toUpperCase(),
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: AppPadding.largePadding),
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppPadding.smallPadding),
                ),
                margin: const EdgeInsets.symmetric(horizontal: AppPadding.mediumPadding),
                child: Padding(
                  padding: const EdgeInsets.all(AppPadding.mediumPadding),
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person, color: AppColors.accentColor),
                        title: Text(
                          'Username',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.hintColor),
                        ),
                        subtitle: Text(
                          currentUser.username,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.textColor),
                        ),
                      ),
                      const Divider(color: AppColors.softGrey),
                      ListTile(
                        leading: const Icon(Icons.email, color: AppColors.accentColor),
                        title: Text(
                          'Email',
                          style: Theme.of(context).textTheme.bodySmall!.copyWith(color: AppColors.hintColor),
                        ),
                        subtitle: Text(
                          currentUser.email,
                          style: Theme.of(context).textTheme.titleMedium!.copyWith(color: AppColors.textColor),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppPadding.largePadding),
              ElevatedButton.icon(
                onPressed: () async {
                  bool confirmLogout = await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Konfirmasi Logout'),
                      content: const Text('Apakah Anda yakin ingin keluar?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: const Text('Batal'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: const Text('Logout'),
                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerColor),
                        ),
                      ],
                    ),
                  ) ?? false; 

                  if (confirmLogout) {
                    await userPresenter.logout();
                    // Setelah logout, arahkan ke halaman login
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dangerColor,
                  foregroundColor: AppColors.primaryColor,
                  minimumSize: const Size.fromHeight(50),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}