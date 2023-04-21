import 'package:flutter/material.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:l8_food/helpers/color_helper.dart';
import 'package:l8_food/helpers/google_signin.dart';
import 'package:l8_food/helpers/image_helper.dart';
import 'package:l8_food/helpers/language_helper.dart';
import 'package:provider/provider.dart';

class SignInWidget extends StatelessWidget {
  const SignInWidget({Key? key}) : super(key: key);

  void _login(context) async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    await provider.googleLogin();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: double.infinity,
        width: double.infinity,
        color: ColorHelper.signInBackground,
        child: Column(
          children: [
            const SizedBox(height: 150),
            Image.asset(
             ImageHelper.signInImage,
              color: ColorHelper.l8ImageColorBlue,
            ),
            const SizedBox(height: 150),
            Text(AppLocale.signUpWithGoogleAccount.getString(context),style: TextStyle(color: ColorHelper.textColorWhite)),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: ColorHelper.signInButtonBackground,
                onPrimary: ColorHelper.signInButtonText,
                minimumSize: const Size(200, 50),
              ),
              label: Text(AppLocale.submitButton.getString(context)),
              onPressed: () => _login(context),
              icon: const FaIcon(FontAwesomeIcons.google),
            ),
          ],
        ),
      ),
    );
  }
}
