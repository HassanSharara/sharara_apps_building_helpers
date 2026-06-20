import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:freerasp/freerasp.dart';
import 'package:sharara_apps_building_helpers/ui.dart';

final class _SHolders {
  _SHolders._();
  static final _SHolders instance = _SHolders._();
  int? a, b, c, d, e, f, g, h;

  @pragma("vm:prefer-inline")
  bool get isInit => [a, b, c, d, e, f, g, h].any((e) => e != null);

  static const int xr = 0x35;

  @pragma("vm:prefer-inline")
  static int generateValue(final int v) => v ^ xr;
}

final class ShararaSecurity1 {
  ShararaSecurity1._();

  static ThreatCallback? _cb;
  static bool _tamperDetected = false;

  static final ValueNotifier<bool> tier1Notifier = ValueNotifier<bool>(true);
  static final StreamController<int> tier2Stream = StreamController<int>.broadcast();
  static final StreamController<Map<String, dynamic>> tier3Stream = StreamController<Map<String, dynamic>>.broadcast();
  static final List<void Function(int stateToken)> tier4Registry = [];

  static InitSecurity? _initSecurity;
  static Future<void> init(final InitSecurity security) async {
    if (_SHolders.instance.isInit) return;
    _initSecurity = security;

    await () async {
      await _layer1((v){
        onThreatDetected(v);

        _tamperDetected = true;
        _executeDefensiveActions(v);
      });
      await _layer2();
      await _layer3();
    }();
  }

  @pragma("vm:prefer-inline")
  static void onThreatDetected(AppThreat threat) {
    _tamperDetected = true;
    _executeDefensiveActions(threat);
  }

  static Future<void> _layer1(Function(AppThreat threat) onThreatDetected) async {

    _SHolders.instance.b = _SHolders.generateValue(43);

        () {
      _SHolders.instance.f = _SHolders.generateValue(17);
      if (_SHolders.instance.b != _SHolders.generateValue(43)) {
        _tamperDetected = true;
        return;
      }

      _cb = ThreatCallback(
        onAppIntegrity: () => onThreatDetected(AppThreat.appIntegrity),
        onObfuscationIssues: () => onThreatDetected(AppThreat.obfuscationIssues),
        onDebug: () {
          onThreatDetected(AppThreat.debug);
        },
        onHooks: () => onThreatDetected(AppThreat.hooks),
        onDeviceBinding: () => onThreatDetected(AppThreat.deviceBinding),
        onDeviceID: () => onThreatDetected(AppThreat.deviceID),
        onPrivilegedAccess: () => onThreatDetected(AppThreat.privilegedAccess),
        onSimulator: () => onThreatDetected(AppThreat.simulator),
        onAutomation: () => onThreatDetected(AppThreat.automation),
        onSystemVPN: () => onThreatDetected(AppThreat.systemVPN),
        onDevMode: () => onThreatDetected(AppThreat.devMode),
        onUnsecureWiFi: () => onThreatDetected(AppThreat.unsecureWiFi),
        onLocationSpoofing: () => onThreatDetected(AppThreat.locationSpoofing),
        onScreenshot: () => onThreatDetected(AppThreat.screenshot),
        onScreenRecording: () => onThreatDetected(AppThreat.screenRecording),
        onMalware: (malwareData) => onThreatDetected(AppThreat.privilegedAccess),
      );
      _SHolders.instance.d = _SHolders.generateValue(40);
    }();

        () {
      if (_SHolders.generateValue(40) != _SHolders.instance.d) {
        _SHolders.instance.d = _SHolders.generateValue(41);
        _tamperDetected = true;
        return;
      }
      _SHolders.instance.g = _SHolders.generateValue(88);
    }();
  }

  static Future<void> _layer2() async {
    int? a = _SHolders.instance.b;
    int? b = _SHolders.instance.f;
    int? c = _SHolders.instance.d;
    int? d = _SHolders.instance.g;

    bool pathValid = (a == _SHolders.generateValue(43)) &&
        (b == _SHolders.generateValue(17)) &&
        (c == _SHolders.generateValue(40)) &&
        (d == _SHolders.generateValue(88));

    if (!pathValid || _tamperDetected) {

      _executeDefensiveActions(AppThreat.appIntegrity);
    } else {
      _SHolders.instance.h = _SHolders.generateValue(99);
      _dispatchBroadcasters(isHealthy: true);
    }
  }

  static Future<void> _layer3() async {
    if (_SHolders.instance.h != _SHolders.generateValue(99) || _cb == null) {
      _executeDefensiveActions(AppThreat.appIntegrity);
      return;
    }
    try {
      Talsec.instance.attachListener(_cb!);

      final config = TalsecConfig(
        androidConfig: AndroidConfig(
          packageName: _initSecurity!.packageName,
          signingCertHashes: _initSecurity!.androidCertHashes,
        ),
        iosConfig: IOSConfig(
          bundleIds: _initSecurity!.iosBundleIds,
          teamId: _initSecurity!.teamId ?? "",
        ),
        watcherMail: _initSecurity!.watcherMail ?? "idi@iasi.com",
      );

      await Talsec.instance.start(config);
      _SHolders.instance.a = _SHolders.generateValue(1);
    } catch (e) {
      print("invoekd  ${e}");
      _executeDefensiveActions(AppThreat.hooks);
    }
  }
  @pragma("vm:prefer-inline")
  static void _dispatchBroadcasters({required bool isHealthy}) {
    final String k = String.fromCharCodes([0x69, 0x6e, 0x74, 0x65, 0x67, 0x72, 0x69, 0x74, 0x79, 0x5f, 0x73, 0x69, 0x67]);

    if (isHealthy) {
      tier1Notifier.value = true;
      tier2Stream.add(0x7F);
      tier3Stream.add({k: [0x4f, 0x4b, 0x5f, 0x30, 0x78, 0x33, 0x35]});

      for (var callback in tier4Registry) {
        callback(0xACED);
      }
    } else {
      tier1Notifier.value = false;
      tier2Stream.add(0x00);
      tier3Stream.add({k: [0x43, 0x52, 0x49, 0x54, 0x49, 0x43, 0x41, 0x4c, 0x5f, 0x45, 0x52, 0x52, 0x5f, 0x54, 0x41, 0x4d, 0x50, 0x45, 0x52, 0x45, 0x44]});

      for (var callback in tier4Registry) {
        callback(0xDEAD);
      }
    }
  }

  @pragma("vm:prefer-inline")
  static void _executeDefensiveActions(AppThreat threat) {

    _SHolders.instance.a = 0;
    _SHolders.instance.b = 0;
    _SHolders.instance.c = 0;
    _SHolders.instance.d = 0;

    _dispatchBroadcasters(isHealthy: false);

    Future.delayed(const Duration(milliseconds: 150), () {
      SystemNavigator.pop();
    });
  }
}

enum AppThreat {
  appIntegrity, obfuscationIssues, debug, hooks, deviceBinding,
  deviceID, privilegedAccess, simulator, automation, systemVPN,
  devMode, unsecureWiFi, locationSpoofing, screenshot, screenRecording
}