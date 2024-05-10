import 'package:flutter/material.dart';
import 'package:mai_f/themes/theme_data.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _emailError;
  bool _isButtonDisabled = true;
  @override
  void initState() {
    super.initState();
    _emailController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      _emailError = _validateEmail(_emailController.text);
    });
  }

  void _clearEmailField() {
    setState(() {
      _emailController.clear();
    });
  }

  String? _validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email address';
    }

    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 50, left: 22, right: 22),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Column(
                children: [
                  SizedBox(
                    width: 240,
                    child: Text(
                      'Enter an email to get started',
                      style: TextStyles.headlineLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Text(
                    'We\'ll send you an email to conform its you.',
                    style: TextStyles.subtitle,
                  )
                ],
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  border: OutlineInputBorder(),
                  errorText: _isButtonDisabled
                      ? null
                      : _validateEmail(_emailController.text),
                  suffixIcon: IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: 20,
                    ),
                    onPressed:
                        _emailController.text.isEmpty ? null : _clearEmailField,
                  ),
                ),
                validator: (value) => _validateEmail(value ?? ''),
              ),
              SizedBox(height: 20),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    String email = _emailController.text;
                    print('Submitted email: $email');
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Next',
                        style: TextStyles.headlineSmall.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
