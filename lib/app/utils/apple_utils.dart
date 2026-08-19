import 'package:collection/collection.dart';

import 'package:wmimo/app/modules/remote_config.dart';
import 'package:wmimo/app/modules/remote_config_manager.dart';
import 'package:wmimo/app/utils/install_referrer_utils.dart';

abstract class AppleUtils {
  static String getTestFlightUrl() {
    final config = RemoteConfigManager.getConfig();
    final name = InstallReferrerUtils.getAppleTestFlightName();
    return _findChannelByName(config.channels, name)?.url ?? "";
  }

  static String getAppStoreUrl() {
    final config = RemoteConfigManager.getConfig();
    final name = InstallReferrerUtils.getAppleAppstoreName();
    return _findChannelByName(config.channels, name)?.url ?? "";
  }

  static RemoteConfigChannel? _findChannelByName(
    List<RemoteConfigChannel> channels,
    String name,
  ) {
    return channels.firstWhereOrNull((channel) => channel.channel == name);
  }
}
