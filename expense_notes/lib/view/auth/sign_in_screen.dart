import 'package:expense_notes/bloc/root/root_cubit.dart';
import 'package:expense_notes/bloc/signIn/sign_in_cubit.dart';
import 'package:expense_notes/bloc/signIn/sign_in_state.dart';
import 'package:expense_notes/routes.dart';
import 'package:expense_notes/style/my_colors.dart';
import 'package:expense_notes/widget/platform_widget/platform_button.dart';
import 'package:expense_notes/widget/platform_widget/platform_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late RootCubit _rootCubit;
  late SignInCubit _signInCubit;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _isSubmitEnable = false;

  @override
  void initState() {
    _rootCubit = BlocProvider.of<RootCubit>(context);
    _signInCubit = BlocProvider.of<SignInCubit>(context);

    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SignInCubit, SignInState>(
        builder: (context, state) {
          return _buildSignInForm(context);
        },
        listener: (context, state) {
          if (state is SignInSuccess) {
            _rootCubit.onAuthenticated();
          } else if (state is SignInFailure) {
            Fluttertoast.showToast(msg: state.message);
          }
        },
      ),
    );
  }

  Widget _buildSignInForm(BuildContext context) {
    PlatformTheme theme = PlatformTheme(context);

    return Center(
      child: SingleChildScrollView(
        child: Padding(
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

              BlocBuilder<SignInCubit, SignInState>(
                builder: (context, state) {
                  return SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: PlatformButton(
                      isLoading: state is SignInLoading,
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
                  );
                },
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
        ),
      ),
    );
  }

  Future _signInUser() async {
    // Close keyboard
    FocusManager.instance.primaryFocus?.unfocus();

    await _signInCubit.signIn(
      email: _emailController.text,
      password: _passwordController.text,
    );
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
