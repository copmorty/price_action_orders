import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:price_action_orders/presentation/bloc/userdata_bloc.dart';

class SpotBalances extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserDataBloc, UserDataState>(
      builder: (context, state) {
        if (state is LoadedUserData) {
          return Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.userData.balances.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.all(8.0),
                  // decoration: BoxDecoration(
                  //   border: Border.all(color: Colors.white),
                  //   borderRadius: BorderRadius.all(Radius.circular(5)),
                  // ),
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Text(state.userData.balances[index].asset),
                      Text(state.userData.balances[index].free.toString()),
                    ],
                  ),
                );
              },
            ),
          );
        }
        return SizedBox();
      },
    );
  }
}
