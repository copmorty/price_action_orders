import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/providers.dart';

class AuthForm extends StatefulWidget {
  final AppMode appMode;

  const AuthForm(this.appMode, {Key? key}) : super(key: key);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _keyController = TextEditingController();
  final TextEditingController _secretController = TextEditingController();
  final FocusNode _secretFocus = FocusNode();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _obscureSecret = true;
  bool _allFieldsCompleted = false;
  bool _loadingOperation = false;
  bool _showAsyncError = false;
  late String _modeText;

  @override
  void initState() {
    super.initState();
    _modeText = widget.appMode == AppMode.TEST ? 'TEST' : 'REAL';
  }

  @override
  void dispose() {
    super.dispose();
    _keyController.dispose();
    _secretController.dispose();
    _secretFocus.dispose();
  }

  void _runMode(AppMode mode, String key, String secret) async {
    setGlobalModeVariables(mode, key, secret);

    Navigator.pushReplacementNamed(context, '/home');
  }

  void _onFormSubmitted() async {
    if (_loadingOperation) return;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final mode = widget.appMode;
      final key = _keyController.text;
      final secret = _secretController.text;

      setState(() => _loadingOperation = true);
      final correctCredentials = await context.read(authHandlerProvider).checkAuthCredentials(mode, key, secret);
      setState(() {
        _loadingOperation = false;
        _showAsyncError = !correctCredentials;
      });

      if (correctCredentials) _runMode(mode, key, secret);
    } else {
      setState(() => _autovalidateMode = AutovalidateMode.always);
    }
  }

  void _checkFormCompletion() {
    _showAsyncError = false;

    if (_keyController.text.isEmpty || _secretController.text.isEmpty)
      setState(() => _allFieldsCompleted = false);
    else
      setState(() => _allFieldsCompleted = true);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: _autovalidateMode,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            Text(_modeText, style: TextStyle(fontWeight: FontWeight.w600)),
            TextFormField(
              controller: _keyController,
              onChanged: (_) => _checkFormCompletion(),
              cursorColor: mainColor,
              decoration: InputDecoration(labelText: 'Key'),
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_secretFocus),
              validator: (value) {
                if (value == null || value.isEmpty) return 'This field cannot be empty';
                return null;
              },
            ),
            TextFormField(
              controller: _secretController,
              focusNode: _secretFocus,
              onChanged: (_) => _checkFormCompletion(),
              obscureText: _obscureSecret,
              cursorColor: mainColor,
              decoration: InputDecoration(
                labelText: 'Secret',
                suffix: IconButton(
                  icon: Icon(_obscureSecret ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscureSecret = !_obscureSecret),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'This field cannot be empty';
                return null;
              },
            ),
            SizedBox(height: 5),
            Opacity(
              opacity: _showAsyncError ? 1 : 0,
              child: Text(
                'We were unable to authenticate your account. Please recheck the fields',
                style: TextStyle(color: errorColor),
              ),
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _allFieldsCompleted ? _onFormSubmitted : null,
              child: _loadingOperation
                  ? LoadingWidget(color: whiteColor, height: 14, width: 14)
                  : Text('Run ' + _modeText + ' mode', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(primary: mainColorDark, minimumSize: Size(double.infinity, 40)),
            )
          ],
        ),
      ),
    );
  }
}
