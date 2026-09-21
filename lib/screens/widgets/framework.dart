import 'package:flutter/widgets.dart';
import 'package:wmimo/app/utils/app_lifecycle_state_notify.dart';
import 'package:wmimo/screens/widgets/routes.dart';

abstract class LasyRenderingStatefulWidget extends StatefulWidget {
  const LasyRenderingStatefulWidget({super.key});
}

abstract class LasyRenderingState<T extends LasyRenderingStatefulWidget>
    extends State<T> {
  late int _hashCode;
  bool _needRedraw = false;
  @override
  void initState() {
    super.initState();
    _hashCode = Object.hashAll([this, this]);
    AppLifecycleStateNofity.onStateResumed(_hashCode, () async {
      _tryRedraw("onStateResumed");
    });
    AppRouteObserver.instance.pushRoute(_hashCode);
    AppRouteObserver.instance.onRouteChanged(_hashCode, () {
      _tryRedraw("onRouteChanged");
    });
  }

  @override
  void dispose() {
    AppLifecycleStateNofity.onStateResumed(_hashCode, null);
    AppRouteObserver.instance.onRouteChanged(_hashCode, null);
    AppRouteObserver.instance.popRoute(_hashCode);

    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (!mounted) {
      return;
    }
    fn();
    _needRedraw = true;
    if (AppLifecycleStateNofity.isPaused()) {
      _print("delay redraw by paused:${T.toString()} $_hashCode ");
      return;
    }
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) {
      _print("delay redraw by route:${T.toString()} $_hashCode");
      return;
    }
    _print("redraw by setState:${T.toString()} $_hashCode");
    _needRedraw = false;
    super.setState(() {});
  }

  void _tryRedraw(String from) {
    if (!mounted) {
      return;
    }
    final route = ModalRoute.of(context);
    if (route != null && !route.isCurrent) {
      return;
    }
    if (!_needRedraw) {
      return;
    }
    _print("redraw by route $from :${T.toString()} $_hashCode");
    _needRedraw = false;
    super.setState(() {});
  }

  void _print(Object? object) {
    //print(object);
  }
}
