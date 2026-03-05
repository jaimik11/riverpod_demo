import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RiverpodNotifierConsumerWidget<StateT, NotifierT extends Notifier<StateT>>
    extends ConsumerWidget {
  final NotifierProvider<NotifierT, StateT> provider;
  final Widget Function(
      BuildContext context,
      WidgetRef ref,
      StateT state,
      NotifierT notifier,
      )
  builder;

  const RiverpodNotifierConsumerWidget({
    super.key,
    required this.provider,
    required this.builder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    return builder(context, ref, state, notifier);
  }
}

/*
class AutoConsumerBuilder<StateT, NotifierT extends AutoDisposeNotifier<StateT>>
    extends ConsumerStatefulWidget {
  final AutoDisposeNotifierProvider<NotifierT, StateT> provider;
  final Widget Function(BuildContext context, StateT state, NotifierT notifier, WidgetRef ref) builder;
  final void Function(StateT previous, StateT next, WidgetRef ref)? listener;

  const AutoConsumerBuilder({
    super.key,
    required this.provider,
    required this.builder,
    this.listener,
  });

  @override
  ConsumerState<AutoConsumerBuilder<StateT, NotifierT>> createState() => _AutoConsumerBuilderState<StateT, NotifierT>();
}

class _AutoConsumerBuilderState<StateT, NotifierT extends AutoDisposeNotifier<StateT>>
    extends ConsumerState<AutoConsumerBuilder<StateT, NotifierT>> {

  late StateT _previousState;

  @override
  void initState() {
    super.initState();
    _previousState = ref.read(widget.provider);
    // Set up listener for changes
    if (widget.listener != null) {
      ref.listen<StateT>(widget.provider, (previous, next) {
        if (previous != next) {
          widget.listener!(previous ?? _previousState, next, ref);
        }
        _previousState = next;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.provider);
    final notifier = ref.read(widget.provider.notifier);
    return widget.builder(context, state, notifier, ref);
  }
}
*/

/// A ConsumerStatefulWidget that:
///  1. Watches `provider` for rebuilding.
///  2. On every build, calls `ref.listen(provider, …)` so you can react to state changes.
///  3. Invokes your `builder(context, state, notifier, ref)`.
///  4. Optionally invokes `listener(previous, next, ref)` whenever the provider’s state changes.
class AutoConsumerBuilder<StateT, NotifierT extends AutoDisposeNotifier<StateT>>
    extends ConsumerWidget {
  final AutoDisposeNotifierProvider<NotifierT, StateT> provider;
  final void Function(StateT previous, StateT next, WidgetRef ref)? listener;
  final Widget Function(
      BuildContext context,
      StateT state,
      NotifierT notifier,
      WidgetRef ref,
      )
  builder;

  const AutoConsumerBuilder({
    super.key,
    required this.provider,
    required this.builder,
    this.listener,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1️⃣ Always watch the provider’s state so that this widget rebuilds when it changes:
    final state = ref.watch(provider);

    // 2️⃣ Register a listener on the provider – this is now inside build, so
    //    we're guaranteed to be “in a build” and won’t hit the “ref.listen can only be used
    //    within the build method of a ConsumerWidget” assertion.
    //
    //    Riverpod ensures that calling ref.listen(...) multiple times during subsequent builds
    //    simply updates the callback; it will not stack‐up multiple listeners.
    ref.listen<StateT>(provider, (previous, next) {
      if (listener != null && previous != next) {
        // If `previous` is null on very first build, you can either guard or pass a dummy.
        // Here, we simply skip if previous == null:
        if (previous != null) {
          listener!(previous, next, ref);
        }
      }
    });

    // 3️⃣ Grab the notifier object once:
    final notifier = ref.read(provider.notifier);

    // 4️⃣ Finally, delegate to your builder:
    return builder(context, state, notifier, ref);
  }
}
