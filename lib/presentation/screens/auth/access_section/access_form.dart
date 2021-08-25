import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/core/globals/variables.dart';
import 'package:price_action_orders/domain/entities/api_access.dart';
import 'package:price_action_orders/presentation/shared/colors.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/providers.dart';

class AccessForm extends StatefulWidget {
  final AppMode appMode;
  final ApiAccess? apiAccess;

  const AccessForm({
    Key? key,
    required this.appMode,
    required this.apiAccess,
  }) : super(key: key);

  @override
  _AccessFormState createState() => _AccessFormState();
}

class _AccessFormState extends State<AccessForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FocusNode _secretFocus = FocusNode();
  AutovalidateMode _autovalidateMode = AutovalidateMode.disabled;
  bool _obscureSecret = true;
  bool _allFieldsCompleted = false;
  bool _loadingOperation = false;
  bool _showAsyncError = false;
  late bool _emptyStorage;
  late String _formTitle;
  late TextEditingController _keyController;
  late TextEditingController _secretController;

  @override
  void initState() {
    super.initState();
    _formTitle = widget.appMode == AppMode.TEST ? 'TEST' : 'REAL';
    _emptyStorage = widget.apiAccess == null;
    _keyController = TextEditingController(text: widget.apiAccess?.key);
    _secretController = TextEditingController(text: widget.apiAccess?.secret);
    _checkFormCompletion();
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
      final correctCredentials = await context.read(authNotifierProvider.notifier).checkAuthCredentials(mode, key, secret);
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

  void _storeCredentials() async {
    if (_allFieldsCompleted) {
      final mode = widget.appMode;
      final key = _keyController.text;
      final secret = _secretController.text;

      final stored = await context.read(authNotifierProvider.notifier).storeCredentials(mode, key, secret);

      if (stored) {
        setState(() {
          _obscureSecret = true;
          _emptyStorage = !stored;
        });
        _showSnackbar();
      } else {
        _showSnackbar(error: true);
      }
    }
  }

  void _clearStorage() async {
    final mode = widget.appMode;

    final clear = await context.read(authNotifierProvider.notifier).clearCredentials(mode);

    if (clear) {
      _keyController.clear();
      _secretController.clear();
      setState(() {
        _showAsyncError = false;
        _emptyStorage = true;
        _allFieldsCompleted = false;
      });
      _showSnackbar();
    } else {
      _showSnackbar(error: true);
    }
  }

  void _showSnackbar({bool error = false}) {
    late String snackBarText;
    final textColor = error ? whiteColor : blackColor;
    final backColor = error ? errorColor : whiteColor;

    if (error) {
      snackBarText = 'Something went wrong';
    } else {
      if (_emptyStorage)
        snackBarText = _formTitle + ' storage cleared successfully';
      else
        snackBarText = _formTitle + ' key and secret successfully stored';
    }

    final snackBar = SnackBar(
      content: Text(
        snackBarText,
        textAlign: TextAlign.center,
        style: TextStyle(color: textColor),
      ),
      backgroundColor: backColor,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            Text(_formTitle, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            TextFormField(
              controller: _keyController,
              enabled: _emptyStorage,
              onChanged: (_) => _checkFormCompletion(),
              cursorColor: mainColor,
              style: TextStyle(color: _emptyStorage ? whiteColor : greyColor),
              decoration: InputDecoration(labelText: 'Key'),
              onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_secretFocus),
              validator: (value) {
                if (value == null || value.isEmpty) return 'This field cannot be empty';
                return null;
              },
            ),
            TextFormField(
              controller: _secretController,
              enabled: _emptyStorage,
              focusNode: _secretFocus,
              onChanged: (_) => _checkFormCompletion(),
              obscureText: _obscureSecret,
              cursorColor: mainColor,
              style: TextStyle(color: _emptyStorage ? whiteColor : greyColor),
              decoration: InputDecoration(
                labelText: 'Secret',
                suffix: IconButton(
                  icon: Icon(_obscureSecret ? Icons.visibility_off : Icons.visibility),
                  color: _emptyStorage ? whiteColor : transparentColor,
                  onPressed: () => setState(() => _obscureSecret = !_obscureSecret),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) return 'This field cannot be empty';
                return null;
              },
            ),
            SizedBox(height: 10),
            Opacity(
              opacity: _showAsyncError ? 1 : 0,
              child: Text(
                'We were unable to authenticate your account. Please recheck the fields',
                style: TextStyle(color: errorColor),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.save),
                  color: mainColor,
                  splashRadius: 25,
                  onPressed: _allFieldsCompleted && _emptyStorage ? _storeCredentials : null,
                  tooltip: 'Store key and secret',
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  color: mainColor,
                  splashRadius: 25,
                  onPressed: _emptyStorage ? null : _clearStorage,
                  tooltip: 'Clear storage',
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _allFieldsCompleted ? _onFormSubmitted : null,
              child: _loadingOperation
                  ? LoadingWidget(color: whiteColor, height: 14, width: 14)
                  : Text('Run ' + _formTitle + ' mode', style: TextStyle(fontSize: 14)),
              style: ElevatedButton.styleFrom(primary: mainColorDark, minimumSize: Size(double.infinity, 40)),
            )
          ],
        ),
      ),
    );
  }
}
