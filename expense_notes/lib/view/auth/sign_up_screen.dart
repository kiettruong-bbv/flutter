import 'package:expense_notes/model/response/auth_response.dart';
import 'package:expense_notes/service/auth_repository.dart';
import 'package:expense_notes/style/my_colors.dart';
import 'package:expense_notes/widget/platform_widget/platform_button.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final IAuthRepository authRepository = HttpAuthRepository();

  SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isSubmitEnable = false;
  bool _isLoading = false;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: _buildSignUpForm(context),
    );
  }

  Widget _buildSignUpForm(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);

    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SIGN UP',
            style: theme.getDefaultTextStyle()?.copyWith(
                  fontSize: 40,
                  color: MyColors.primary,
                ),
          ),

          const SizedBox(height: 60),

          // EMAIL
          TextField(
            controller: _emailController,
            style: theme.getDefaultTextStyle()?.copyWith(
                  fontSize: 16,
                  textBaseline: TextBaseline.alphabetic,
                ),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.darkGrey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.primary),
              ),
              contentPadding: EdgeInsets.all(10),
              hintText: 'Email',
              hintStyle: TextStyle(
                color: MyColors.darkGrey,
              ),
            ),
            onChanged: (_) => _validateButton(),
          ),

          const SizedBox(height: 30),

          // PASSWORD
          TextField(
            controller: _passwordController,
            style: theme.getDefaultTextStyle()?.copyWith(
                  fontSize: 16,
                  textBaseline: TextBaseline.alphabetic,
                ),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.darkGrey),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: MyColors.primary),
              ),
              contentPadding: EdgeInsets.all(10),
              hintText: 'Password',
              hintStyle: TextStyle(
                color: MyColors.darkGrey,
              ),
            ),
            obscureText: true,
            onChanged: (_) => _validateButton(),
          ),

          const SizedBox(height: 50),

          SizedBox(
            height: 50,
            width: double.infinity,
            child: PlatformButton(
              isLoading: _isLoading,
              borderRadius: BorderRadius.circular(18),
              onPressed: _isSubmitEnable ? _signUpUser : null,
              child: Text(
                'Sign In',
                style: theme.getButtonTextStyle()?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
            ),
          ),

          const SizedBox(height: 50),
        ],
      ),
    );
  }

  Future _signUpUser() async {
    setState(() {
      _isLoading = true;
    });
    final AuthResponse? response = await widget.authRepository.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );
    if (response != null) {
      Navigator.pop(context);
    }
  }

  void _validateButton() {
    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty) {
      if (_isSubmitEnable) {
        return;
      }
      setState(() {
        _isSubmitEnable = true;
      });
    } else {
      setState(() {
        _isSubmitEnable = false;
      });
    }
  }
}
