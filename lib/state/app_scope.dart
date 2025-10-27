<<<<<<< HEAD

import 'package:flutter/widgets.dart';
import 'app_state.dart';
class AppScope extends InheritedNotifier<AppState>{
  const AppScope({super.key, required AppState super.notifier, required this.child}):super(child:child);
  final Widget child;
  static AppState of(BuildContext context){
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope!=null,'AppScope not found');
=======
import 'package:flutter/widgets.dart';
import 'app_state.dart';

class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState super.notifier, required this.child}) : super(child: child);
  final Widget child;

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope not found');
>>>>>>> fe0a9a2 (Milestone 2)
    return scope!.notifier!;
  }
}
