import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhir_praktpm/presenters/user_presenter.dart';
import 'package:projekakhir_praktpm/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userPresenter = Provider.of<UserPresenter>(context, listen: false);

      try {
        final user = await userPresenter.login(
          _emailController.text,
          _passwordController.text,
        );

        if (user != null) {
          _showSuccessSnackbar('Login berhasil! Selamat datang, ${user.username}!');
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          _showErrorSnackbar('Email atau password salah.');
        }
      } catch (e) {
        _showErrorSnackbar(e.toString().replaceFirst('Exception: ', ''));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.dangerColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.successColor,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppPadding.mediumPadding),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  AppConstants.appName,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                        color: AppColors.accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  AppConstants.appSubtitle,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: AppColors.secondaryTextColor,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppPadding.largePadding),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan alamat email Anda',
                    prefixIcon: const Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Masukkan email yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppPadding.mediumPadding),
                TextFormField(
                  controller: _passwordController,
                  obscureText: !_passwordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password Anda',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.hintColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppPadding.largePadding),
                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.accentColor)
                    : ElevatedButton(
                        onPressed: _login,
                        child: const Text('Login'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50), // Full width button
                        ),
                      ),
                const SizedBox(height: AppPadding.mediumPadding),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/register');
                  },
                  child: Text(
                    'Belum punya akun? Daftar di sini.',
                    style: TextStyle(color: AppColors.linkColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}