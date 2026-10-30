import 'package:flutter_test/flutter_test.dart';
import 'package:libclash_vpn_service/state.dart';
import 'package:wmimo/app/local_services/vpn_service.dart';
import 'package:wmimo/app/utils/vpn_action_handler.dart';

void main() {
  group('VpnUiStatus & Sidebar Connect Button State Sync', () {
    setUp(() {
      VpnActionHandler.uiStatus.value = const VpnUiStatus();
      VPNService.onEventStateChanged.clear();
    });

    test('Initial disconnected state shows not connected and not transitioning', () {
      const status = VpnUiStatus(
        state: FlutterVpnServiceState.disconnected,
        desiredConnected: null,
        isOperating: false,
      );
      expect(status.isConnected, isFalse);
      expect(status.isTransitioning, isFalse);
    });

    test('Clicking connect immediately enters transitioning state', () {
      VpnActionHandler.updateUiStatus(desiredConnected: true);
      final status = VpnActionHandler.uiStatus.value;
      expect(status.isTransitioning, isTrue);
      expect(status.isConnected, isFalse);
    });

    test(
      'Reaching connected state while VPNService.isOperating is still true '
      'immediately settles to connected (never stuck on connecting)',
      () {
        // Simulate core emitting connected while VPNService.start() is still
        // executing post-connect tasks (setSystemProxy / setConfigsMode) with
        // isOperating == true.
        final statusWhilePostStartRunning = const VpnUiStatus(
          state: FlutterVpnServiceState.connected,
          desiredConnected: null,
          isOperating: true,
        );

        expect(statusWhilePostStartRunning.isTransitioning, isFalse);
        expect(statusWhilePostStartRunning.isConnected, isTrue);
      },
    );

    test(
      'VPNService.notifyStateChanged updates VpnActionHandler.uiStatus and '
      'clears desiredConnected when connected or disconnected',
      () {
        final receivedStates = <FlutterVpnServiceState>[];
        VPNService.onEventStateChanged.add((state, _) {
          receivedStates.add(state);
        });

        VpnActionHandler.updateUiStatus(
          state: FlutterVpnServiceState.connecting,
          desiredConnected: true,
          isOperating: true,
        );
        expect(VpnActionHandler.uiStatus.value.isTransitioning, isTrue);

        VPNService.notifyStateChanged(FlutterVpnServiceState.connected);
        expect(receivedStates, [FlutterVpnServiceState.connected]);
        expect(VpnActionHandler.uiStatus.value.state, FlutterVpnServiceState.connected);
        expect(VpnActionHandler.uiStatus.value.desiredConnected, isNull);
        expect(VpnActionHandler.uiStatus.value.isTransitioning, isFalse);
        expect(VpnActionHandler.uiStatus.value.isConnected, isTrue);

        VPNService.notifyStateChanged(FlutterVpnServiceState.disconnected);
        expect(VpnActionHandler.uiStatus.value.state, FlutterVpnServiceState.disconnected);
        expect(VpnActionHandler.uiStatus.value.isTransitioning, isFalse);
        expect(VpnActionHandler.uiStatus.value.isConnected, isFalse);
      },
    );

    test('Requesting disconnect while connected enters transitioning state', () {
      const status = VpnUiStatus(
        state: FlutterVpnServiceState.connected,
        desiredConnected: false,
        isOperating: true,
      );
      expect(status.isTransitioning, isTrue);
      expect(status.isConnected, isFalse);
    });
  });
}
