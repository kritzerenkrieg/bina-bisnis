// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:buang_bijak/theme.dart';
import 'package:flutter/material.dart';
import 'package:buang_bijak/screens/home_screen.dart';
// import 'package:buang_bijak/screens/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:buang_bijak/widgets/button.dart';

class LoginSignup extends StatelessWidget {
  const LoginSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return SplashScreen(); // Langsung panggil SplashScreen tanpa MaterialApp
  }
}

// Splash Screen tetap sama seperti yang sudah ada
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () {
      if (!context.mounted) return;

      // Periksa apakah user masih login
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // User masih login, arahkan ke halaman utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const HomeScreen(
                    isAdmin: false,
                  )),
        );
      } else {
        // User belum login, arahkan ke halaman login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    });

    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: EdgeInsets.zero,
              child: Image.asset(
                'assets/images/gambarlanding.png',
                width: 344,
                height: 522,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 240),
            child: Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Image.asset('assets/images/logonama.png', height: 45),
                  const SizedBox(height: 20),
                  Text(
                    'Bijak Kelola Barang dan Sampah',
                    style: bold16.copyWith(color: grey2),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Login Screen
// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isObscured = true;

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (userSnapshot.hasData) {
                return const HomeScreen(isAdmin: false);
              }

              return const Center(child: Text('No user data found.'));
            },
          );
        }

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 50),
                      Padding(
                        padding: const EdgeInsets.only(top: 160, bottom: 24),
                        child: Image.asset('assets/images/logonama.png',
                            height: 60),
                      ),
                      Text(
                        'Bijak Kelola Barang dan Sampah',
                        style: bold14.copyWith(color: grey2),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 64),
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: grey3, width: 2),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: grey3, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: grey3, width: 2),
                          ),
                          filled: true,
                          fillColor: white,
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          labelText: 'Email',
                          labelStyle: regular14,
                        ),
                      ),
                      const SizedBox(height: 16),
                      StatefulBuilder(
                        builder: (context, setState) {
                          return TextField(
                            controller: passwordController,
                            obscureText: _isObscured,
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: grey3, width: 2),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: grey3, width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: grey3, width: 2),
                              ),
                              filled: true,
                              fillColor: white,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              labelText: 'Password',
                              labelStyle: regular14,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isObscured
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: grey3,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isObscured = !_isObscured;
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),
                      Button(
                        text: 'Masuk',
                        color: green,
                        textColor: black,
                        onPressed: () async {
                          final email = usernameController.text.trim();
                          final password = passwordController.text.trim();

                          if (email.isEmpty || password.isEmpty) {
                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Error'),
                                  content: const Text(
                                      'Email dan Password tidak boleh kosong.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return;
                          }

                          try {
                            showDialog(
                              context: context,
                              builder: (context) => const Center(
                                  child: CircularProgressIndicator()),
                            );

                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                              email: email,
                              password: password,
                            );

                            final user = userCredential.user;

                            if (user != null) {
                              final userDoc = await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user.uid)
                                  .get();

                              if (userDoc.exists) {
                                if (userDoc['isAdmin'] == true) {
                                  await userDoc.reference
                                      .update({'isAdmin': true});
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(isAdmin: true)),
                                    );
                                  }
                                } else {
                                  await userDoc.reference
                                      .update({'isAdmin': false});
                                  if (context.mounted) {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const HomeScreen(isAdmin: false)),
                                    );
                                  }
                                }
                              }
                            }
                          } catch (e) {
                            String errorMessage =
                                'Terjadi kesalahan. Silakan coba lagi.';
                            if (e is FirebaseAuthException) {
                              switch (e.code) {
                                case 'user-not-found':
                                  errorMessage = 'Pengguna tidak ditemukan.';
                                  break;
                                case 'wrong-password':
                                  errorMessage = 'Kata sandi atau email salah.';
                                  break;
                                case 'invalid-email':
                                  errorMessage = 'Kata sandi atau email salah.';
                                  break;
                              }
                            }

                            Navigator.pop(context);

                            if (context.mounted) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Login Gagal'),
                                  content: Text(errorMessage),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              );
                            }
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => RegistrationScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'Belum mempunyai akun? Daftar',
                          style: bold14.copyWith(color: grey2),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Registration Screen
// ignore: must_be_immutable
class RegistrationScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool _isObscured = true;

  RegistrationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 160, bottom: 24),
                    child:
                        Image.asset('assets/images/logonama.png', height: 60),
                  ),
                  Text(
                    'Bijak Kelola Barang dan Sampah',
                    style: bold14.copyWith(color: grey2),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 64),
                  TextField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      labelStyle: regular14,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      filled: true,
                      fillColor: white,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: fullNameController,
                    decoration: InputDecoration(
                      labelText: 'Nama Lengkap',
                      labelStyle: regular14,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      filled: true,
                      fillColor: white,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: regular14,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      filled: true,
                      fillColor: white,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 16),
                  StatefulBuilder(builder: (context, setState) {
                    return TextField(
                      controller: passwordController,
                      obscureText: _isObscured,
                      decoration: InputDecoration(
                        labelText: 'Kata Sandi',
                        labelStyle: regular14,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: grey3, width: 2),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: grey3, width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: grey3, width: 2),
                        ),
                        filled: true,
                        fillColor: white,
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isObscured
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: grey3,
                          ),
                          onPressed: () {
                            setState(() {
                              _isObscured = !_isObscured;
                            });
                          },
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 16),
                  TextField(
                    controller: addressController,
                    decoration: InputDecoration(
                      labelText: 'Alamat',
                      labelStyle: regular14,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: grey3, width: 2),
                      ),
                      filled: true,
                      fillColor: white,
                      border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12))),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Button(
                    onPressed: () async {
                      try {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // Agar tidak dapat dismiss secara manual.
                          builder: (context) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                        // Proses registrasi Firebase
                        UserCredential userCredential = await FirebaseAuth
                            .instance
                            .createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        if (userCredential.user != null) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userCredential.user!.uid)
                              .set({
                            'username': usernameController.text.trim(),
                            'fullName': fullNameController.text.trim(),
                            'email': emailController.text.trim(),
                            'address': addressController.text.trim(),
                            'createdAt': FieldValue.serverTimestamp(),
                            'isAdmin': false,
                          });

                          Navigator.pop(context); // Menghapus dialog loading.

                          if (!context.mounted) return;
                          Navigator.pop(
                              context); // Kembali ke halaman sebelumnya.
                        }
                      } catch (e) {
                        String errorMessage =
                            'Terjadi kesalahan. Silakan coba lagi.';
                        if (e is FirebaseAuthException) {
                          switch (e.code) {
                            case 'email-already-in-use':
                              errorMessage = 'Email sudah ada yang pakai.';
                              break;
                            case 'invalid-email':
                              errorMessage = 'Email tidak valid.';
                              break;
                            case 'weak-password':
                              errorMessage = 'Kata sandi terlalu lemah.';
                              break;
                          }
                        }

                        Navigator.pop(context); // Menghapus dialog loading.
                        // print('Registration Error: $e');
                        if (context.mounted) {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Registration Failed'),
                              content: Text(errorMessage),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('OK'))
                              ],
                            ),
                          );
                        }
                      }
                    },
                    color: green,
                    textColor: black,
                    text: 'Daftar',
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Kembali ke halaman Login
                    },
                    child: Text('Sudah mempunyai akun? Masuk',
                        style: bold14.copyWith(
                          color: grey2,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
