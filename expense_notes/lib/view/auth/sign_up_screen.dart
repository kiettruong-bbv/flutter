import 'package:expense_notes/model/auth_model.dart';
import 'package:expense_notes/style/my_colors.dart';
import 'package:expense_notes/widget/platform_widget/platform_button.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

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
              onPressed: _isSubmitEnable ? _signUpUser : null,
              child: Text(
                'Sign Up',
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
    final AuthModel authModel = context.read<AuthModel>();
    final bool signUpResult = await authModel.signUp(
      email: _emailController.text,
      password: _passwordController.text,
    );
    setState(() {
      _isLoading = false;
    });
    if (signUpResult) {
      _showSignUpSuccessDialog();
    } else {
      await Fluttertoast.showToast(msg: 'Sign up failed.');
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

  void _showSignUpSuccessDialog() {
    showDialog<String>(
      context: context,
      useRootNavigator: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sign up successfully.'),
        content: const Text('Please sign in to start using app.'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text(
              'OK',
              style: TextStyle(color: MyColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
