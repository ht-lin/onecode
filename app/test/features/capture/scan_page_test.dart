import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/core/router/app_router.dart';
import 'package:onecode/core/router/routes.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/data/providers.dart';
import 'package:onecode/features/capture/data/camera_permission_service.dart';
import 'package:onecode/features/capture/domain/scan_result.dart';
import 'package:onecode/features/capture/presentation/scan_page.dart';
import 'package:onecode/features/capture/presentation/scanner_view.dart';
import 'package:onecode/l10n/app_localizations.dart';

/// 权限 fake：状态与请求结果可配置，记录跳设置次数。
class _FakePermissionService implements CameraPermissionService {
  _FakePermissionService(this.current);

  CameraPermission current;
  CameraPermission? requestResult;
  int settingsOpened = 0;

  @override
  Future<CameraPermission> status() async => current;

  @override
  Future<CameraPermission> request() async =>
      current = requestResult ?? current;

  @override
  Future<void> openSystemSettings() async => settingsOpened++;
}

/// 取景 fake：按钮触发识别回调（无相机平台通道）。
Widget _fakeScanner(ValueChanged<ScanResult> onDetect) {
  const result =
      ScanResult(value: '4006381333931', format: CodeFormat.ean13);
  // 居中避开扫码态的透明 AppBar（extendBodyBehindAppBar 会盖住 body 顶部）。
  return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    TextButton(
      onPressed: () => onDetect(result),
      child: const Text('emit'),
    ),
    TextButton(
      onPressed: () {
        onDetect(result);
        onDetect(result);
      },
      child: const Text('emit-twice'),
    ),
  ]);
}

void main() {
  late AppDatabase db;
  late _FakePermissionService permission;
  late ProviderContainer container;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    permission = _FakePermissionService(CameraPermission.granted);
    container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      cameraPermissionServiceProvider.overrideWithValue(permission),
      scannerViewBuilderProvider.overrideWithValue(_fakeScanner),
    ]);
  });

  tearDown(() async {
    container.dispose();
    await db.close();
  });

  Future<void> pumpScanPage(WidgetTester tester) async {
    final router = container.read(appRouterProvider);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(
          routerConfig: router,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
        ),
      ),
    );
    router.push(AppRoutes.scan);
    await tester.pumpAndSettle();
  }

  group('识别流程（权限已授予）', () {
    testWidgets('识别成功弹出预览：码值 + 码制', (tester) async {
      await pumpScanPage(tester);
      expect(find.text('emit'), findsOneWidget); // 取景视图（fake）在场

      await tester.tap(find.text('emit'));
      await tester.pumpAndSettle();

      expect(find.text('Code detected'), findsOneWidget);
      expect(find.text('4006381333931'), findsOneWidget);
      expect(find.text('EAN-13'), findsOneWidget);
    });

    testWidgets('确认后替换为编辑页，码值与码制预填', (tester) async {
      await pumpScanPage(tester);
      await tester.tap(find.text('emit'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Use code'));
      await tester.pumpAndSettle();

      // 扫码页已被替换，编辑页预填扫描结果。
      // "Add card" 出现两处：编辑页标题 + 空名称时的卡面预览占位。
      expect(find.byType(ScanPage), findsNothing);
      expect(find.text('Add card'), findsNWidgets(2));
      expect(find.text('4006381333931'), findsOneWidget);
      expect(find.text('EAN-13'), findsOneWidget);
    });

    testWidgets('重新扫描：关闭预览回到取景', (tester) async {
      await pumpScanPage(tester);
      await tester.tap(find.text('emit'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Scan again'));
      await tester.pumpAndSettle();

      expect(find.text('Code detected'), findsNothing);
      expect(find.byType(ScanPage), findsOneWidget);
    });

    testWidgets('防抖：同一码连续触发只弹一次预览', (tester) async {
      await pumpScanPage(tester);
      await tester.tap(find.text('emit-twice'));
      await tester.pumpAndSettle();

      expect(find.text('Code detected'), findsOneWidget);
    });
  });

  group('权限分支', () {
    testWidgets('未授予：先显示请求文案，授予后进入取景', (tester) async {
      permission
        ..current = CameraPermission.denied
        ..requestResult = CameraPermission.granted;
      await pumpScanPage(tester);

      expect(find.text('Allow camera access'), findsOneWidget);
      expect(find.text('emit'), findsNothing);

      await tester.tap(find.text('Allow camera access'));
      await tester.pumpAndSettle();

      expect(find.text('emit'), findsOneWidget);
    });

    testWidgets('请求被拒：引导页可跳系统设置', (tester) async {
      permission
        ..current = CameraPermission.denied
        ..requestResult = CameraPermission.permanentlyDenied;
      await pumpScanPage(tester);

      await tester.tap(find.text('Allow camera access'));
      await tester.pumpAndSettle();

      expect(find.text('Open settings'), findsOneWidget);
      await tester.tap(find.text('Open settings'));
      await tester.pumpAndSettle();
      expect(permission.settingsOpened, 1);
    });

    testWidgets('已永久拒绝：直接显示引导页', (tester) async {
      permission.current = CameraPermission.permanentlyDenied;
      await pumpScanPage(tester);

      expect(find.text('Open settings'), findsOneWidget);
      expect(find.text('Allow camera access'), findsNothing);
    });
  });
}
