import 'package:expense_notes/model/auth_model.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/style/my_colors.dart';
import 'package:expense_notes/widget/platform_widget/platform_button.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
      body: _buildSignInForm(context),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);

    return Container(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SIGN IN',
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
                  color: Colors.black,
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
                  color: Colors.black,
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
              onPressed: _isSubmitEnable ? _signInUser : null,
              child: Text(
                'Sign In',
                style: theme.getButtonTextStyle()?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 50,
            width: double.infinity,
            child: TextButton(
              onPressed: () => _navigateToSignUp(),
              child: Text(
                'Create an account',
                style: theme.getButtonTextStyle()?.copyWith(
                      color: MyColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future _signInUser() async {
    setState(() {
      _isLoading = true;
    });
    final AuthModel authModel = context.read<AuthModel>();
    final bool signInResult = await authModel.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (!signInResult) {
      await Fluttertoast.showToast(msg: 'Sign in failed.');
    }
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, Routes.signUp);
  }

  void _validateButton() {
    setState(() {
      _isSubmitEnable = _emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty;
    });
  }
}
