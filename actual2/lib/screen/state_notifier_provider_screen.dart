import 'package:actual2/layout/default_layout.dart';
import 'package:actual2/model/shopping_item_model.dart';
import 'package:actual2/riverpod/state_notifier_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StateNotifierProviderScreen extends ConsumerWidget {
  const StateNotifierProviderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<ShoppingItemModel> state = ref.watch(shoppingListProvider);

    return DefaultLayout(
      title: 'StateNotifierProvider',
      body: ListView(
        children: state.map(
          (e) => Text(e.name),
        ).toList(),
      ),
    );
  }
}
