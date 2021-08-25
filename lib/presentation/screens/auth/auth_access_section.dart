import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:price_action_orders/core/globals/enums.dart';
import 'package:price_action_orders/presentation/logic/auth_state_notifier.dart';
import 'package:price_action_orders/presentation/shared/widgets/loading_widget.dart';
import 'package:price_action_orders/providers.dart';
import 'access_section/access_form.dart';

class AccessSection extends ConsumerWidget {
  const AccessSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final authState = watch(authNotifierProvider);

    if (authState is AuthInitial) return SizedBox.shrink();
    if (authState is AuthLoading) return LoadingWidget();
    if (authState is AuthLoaded) return _AccessDisplay(authState);

    return SizedBox.shrink();
  }
}

class _AccessDisplay extends StatelessWidget {
  final AuthLoaded authLoaded;

  const _AccessDisplay(this.authLoaded, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: AccessForm(
            appMode: AppMode.TEST,
            apiAccess: authLoaded.testApiAccess,
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width / 2,
          child: AccessForm(
            appMode: AppMode.PRODUCTION,
            apiAccess: authLoaded.prodApiAccess,
          ),
        ),
      ],
    );
  }
}
