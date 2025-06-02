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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.accentColor,
                      foregroundColor: AppColors.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppPadding.tinyPadding),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: AppPadding.largePadding, vertical: AppPadding.mediumPadding),
                      elevation: 0,
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: const Text(
                      'Login Sekarang',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
                      backgroundColor: AppColors.primaryColor, // Background card AlertDialog
                      shape: RoundedRectangleBorder( // Bentuk AlertDialog
                        borderRadius: BorderRadius.circular(AppPadding.smallPadding),
                      ),
                      title: Text(
                        'Konfirmasi Logout',
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: AppColors.textColor, // Warna teks judul
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      content: Text(
                        'Apakah Anda yakin ingin keluar?',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: AppColors.secondaryTextColor, // Warna teks konten
                            ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text(
                            'Batal',
                            style: TextStyle(color: AppColors.textColor), // Warna teks tombol Batal
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dangerColor,
                            foregroundColor: AppColors.textColor, // Pastikan teks tombol juga putih
                            shape: RoundedRectangleBorder( // Radius tombol
                              borderRadius: BorderRadius.circular(AppPadding.tinyPadding),
                            ),
                            elevation: 0, // Hilangkan shadow
                          ),
                          child: Text(
                            'Logout',
                            style: TextStyle(
                                color: AppColors.textColor, 
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ) ?? false; 

                  if (confirmLogout) {
                    await userPresenter.logout();
                    Navigator.of(context).pushReplacementNamed('/login');
                  }
                },
                icon: const Icon(Icons.logout),
                label: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: AppColors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.dangerColor,
                  foregroundColor: AppColors.textColor,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppPadding.tinyPadding),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}