import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/google_signin.dart';
import 'package:l8_food/helpers/image_helper.dart';
import 'package:provider/provider.dart';

class SigninWidget extends StatelessWidget {
  const SigninWidget({Key? key}) : super(key: key);

  void _login(context) async {
    final provider = Provider.of<GoogleSigninProvider>(context, listen: false);
    await provider.googleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: ColorHelper.signinBackground,
        child: Column(
          children: [
            const SizedBox(height: 150),
            Image.asset(
             ImageHelper.signinImage,
              color: ColorHelper.l8ImageColorBlue,
            ),
            const SizedBox(height: 150),
            Text('Sign in with your lioneight google account:',style: TextStyle(color: ColorHelper.textColorWhite)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: ColorHelper.signInButtonBackground,
                onPrimary: ColorHelper.signInButtonText,
                minimumSize: const Size(200, 50),
              ),
              label: const Text('Sign Up with Google'),
              onPressed: () => _login(context),
              icon: const FaIcon(FontAwesomeIcons.google),
            ),
          ],
        ),
      ),
    );
  }
}
