import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // IMPORT PACKAGE SHARED PREFERENCES

import './dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _username = TextEditingController();
  final _password = TextEditingController();

  bool isObscure = true;
  late bool newUser;

  @override
  void initState() {
    super.initState();
    checkIfAlreadyLogin();
  }

  checkIfAlreadyLogin() async {
    SharedPreferences loginData = await SharedPreferences.getInstance();
    newUser = (loginData.getBool('isLogin') ?? true);

    if(newUser == false) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
        arguments: "Successfully logged in"
      );
    }
  }

  Future<void> _login() async {
    if (formKey.currentState!.validate()) {
      SharedPreferences loginData = await SharedPreferences.getInstance();
      String? registeredUsername = loginData.getString('registered_username');
      String? registeredPassword = loginData.getString('registered_password');

      // Cek apakah user sudah pernah registrasi
      if ((registeredUsername != null && registeredPassword != null) &&
        _username.text.trim() == registeredUsername &&
        _password.text.trim() == registeredPassword) {
        await loginData.setBool('isLogin', true);
        await loginData.setString('username', _username.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Berhasil login'), backgroundColor: Colors.green,),
        );
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('login gagal'), backgroundColor: Colors.red,),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 320,
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text("Silahkan Login", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox( height: 18 ),

                  TextFormField(
                    validator: (value) {
                      if(value==null || value.isEmpty) {
                        return "Silahkan isi";
                      }
                      return null;
                    },
                    controller: _username,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                      labelText: "Username"
                    ),
                  ),
                  SizedBox( height: 12 ),

                  TextFormField(
                    validator: (value) {
                      if(value==null || value.isEmpty) {
                        return "Silahkan isi";
                      }
                      return null;
                    },
                    controller: _password,
                    obscureText: isObscure,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Password",
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            isObscure = !isObscure;
                          });
                        }, 
                        icon: Icon(isObscure ? Icons.visibility : Icons.visibility_off)) 
                    ),
                  ),
                  SizedBox( height: 18 ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login, 
                      child: Text("Login", style: TextStyle(color: Colors.black),)
                    ),
                  ),
                  SizedBox( height: 12 ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context, 
                          '/register', 
                          (route) => true
                        );
                      }, 
                      child: Text("Register", style: TextStyle(color: Colors.black),)
                    ),
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