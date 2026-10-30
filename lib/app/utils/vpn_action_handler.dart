import 'package:flutter/foundation.dart';
import 'package:libclash_vpn_service/state.dart';

@immutable
class VpnUiStatus {
  final FlutterVpnServiceState state;
  final bool? desiredConnected;
  final bool isOperating;

  const VpnUiStatus({
    this.state = FlutterVpnServiceState.disconnected,
    this.desiredConnected,
    this.isOperating = false,
  });

  /// Whether the VPN is effectively connected and settled (not transitioning).
  bool get isConnected =>
      !isTransitioning && state == FlutterVpnServiceState.connected;

  /// Whether the VPN is currently in a connecting/disconnecting transition.
  /// Once [state] reaches [FlutterVpnServiceState.connected] (and the user has
  /// not requested a disconnect), this returns `false` even if `VPNService`
  /// post-start housekeeping ([isOperating]) has not yet exited its `finally`
  /// block.
  bool get isTransitioning {
    if (state == FlutterVpnServiceState.connected) {
      return desiredConnected == false;
    }
    if (desiredConnected == true) {
      return true;
    }
    return state == FlutterVpnServiceState.connecting ||
        state == FlutterVpnServiceState.disconnecting ||
        state == FlutterVpnServiceState.reasserting ||
        isOperating;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VpnUiStatus &&
          runtimeType == other.runtimeType &&
          state == other.state &&
          desiredConnected == other.desiredConnected &&
          isOperating == other.isOperating;

  @override
  int get hashCode => Object.hash(state, desiredConnected, isOperating);
}

class VpnActionHandler {
  static void Function(String, bool)? vpnConnect;
  static void Function(String, bool)? vpnDisconnect;
  static void Function(String, bool)? vpnReconnect;

  static final ValueNotifier<VpnUiStatus> uiStatus = ValueNotifier<VpnUiStatus>(
    const VpnUiStatus(),
  );

  static void updateUiStatus({
    FlutterVpnServiceState? state,
    bool? desiredConnected,
    bool clearDesiredConnected = false,
    bool? isOperating,
  }) {
    final current = uiStatus.value;
    uiStatus.value = VpnUiStatus(
      state: state ?? current.state,
      desiredConnected: clearDesiredConnected
          ? null
          : (desiredConnected ?? current.desiredConnected),
      isOperating: isOperating ?? current.isOperating,
    );
  }
}
