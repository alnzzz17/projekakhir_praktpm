import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:projekakhir_praktpm/models/user_model.dart';
import 'package:projekakhir_praktpm/presenters/user_presenter.dart';
import 'package:projekakhir_praktpm/utils/constants.dart';
import 'package:uuid/uuid.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final userPresenter = Provider.of<UserPresenter>(context, listen: false);
      final uuid = const Uuid();
      
      try {
        if (_passwordController.text != _confirmPasswordController.text) {
          _showErrorSnackbar('Konfirmasi password tidak cocok.');
          return;
        }

        final newUser = User(
          id: uuid.v4(), 
          username: _usernameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );

        await userPresenter.register(newUser);

        _showSuccessSnackbar('Registrasi berhasil! Silakan login.');
        Navigator.pushReplacementNamed(context, '/login'); 
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
        title: const Text('Daftar Akun Baru'),
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
                const SizedBox(height: AppPadding.largePadding),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    hintText: 'Masukkan username Anda',
                    prefixIcon: const Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppPadding.mediumPadding),
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
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppPadding.mediumPadding),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password',
                    hintText: 'Konfirmasi password Anda',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: AppColors.hintColor,
                      ),
                      onPressed: () {
                        setState(() {
                          _confirmPasswordVisible = !_confirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi password tidak boleh kosong';
                    }
                    if (value != _passwordController.text) {
                      return 'Password tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppPadding.largePadding),
                _isLoading
                    ? const CircularProgressIndicator(color: AppColors.accentColor)
                    : ElevatedButton(
                        onPressed: _register,
                        child: const Text('Daftar'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                        ),
                      ),
                const SizedBox(height: AppPadding.mediumPadding),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Text(
                    'Sudah punya akun? Login di sini.',
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