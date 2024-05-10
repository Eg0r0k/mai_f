import 'package:flutter/material.dart';
import 'package:mai_f/themes/theme_data.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(22),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Spacer(),
          Container(
            width: double.infinity,
            child: Column(
              children: [
                Row(children: [
                  Expanded(
                      child: FilledButton(
                    onPressed: () {
                      Navigator.pushNamed(context,
                          '/registration'); 
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 20.0),
                      child: Text(
                        'Get Started',
                        style: TextStyles.headlineSmall
                            .copyWith(color: Colors.white),
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ))
                ]),
                Container(
                  margin: EdgeInsets.only(top: 12),
                  width: 400,
                  child: Text(
                    "By proceeding to use Shop, you agree to our terms of service and privacy policy",
                    textAlign: TextAlign.center,
                    style: TextStyles.body
                        .copyWith(color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
