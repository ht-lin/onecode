import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:onecode/core/router/app_router.dart';
import 'package:onecode/core/router/routes.dart';
import 'package:onecode/data/drift/app_database.dart';
import 'package:onecode/data/providers.dart';
import 'package:onecode/features/capture/data/gallery_image_picker.dart';
import 'package:onecode/features/capture/data/image_code_analyzer.dart';
import 'package:onecode/features/capture/domain/scan_result.dart';
import 'package:onecode/features/capture/presentation/image_capture_page.dart';
import 'package:onecode/l10n/app_localizations.dart';

/// 选图 fake：按调用次数依次返回预置路径（null = 用户取消）。
class _FakeGalleryPicker implements GalleryImagePicker {
  _FakeGalleryPicker(this.paths);

  final List<String?> paths;
  int calls = 0;

  @override
  Future<String?> pickImagePath() async => paths[calls++];
}

/// 识别 fake：按图片路径返回预置候选。
class _FakeAnalyzer implements ImageCodeAnalyzer {
  _FakeAnalyzer(this.byPath);

  final Map<String, List<ScanResult>> byPath;

  @override
  Future<List<ScanResult>> analyze(String path) async =>
      byPath[path] ?? const [];
}

void main() {
  late AppDatabase db;

  setUp(() => db = AppDatabase(NativeDatabase.memory()));
  tearDown(() => db.close());

  Future<void> pumpImageCapturePage(
    WidgetTester tester, {
    required List<String?> pickedPaths,
    Map<String, List<ScanResult>> analyzed = const {},
  }) async {
    final container = ProviderContainer(overrides: [
      appDatabaseProvider.overrideWithValue(db),
      galleryImagePickerProvider
          .overrideWithValue(_FakeGalleryPicker(pickedPaths)),
      imageCodeAnalyzerProvider.overrideWithValue(_FakeAnalyzer(analyzed)),
    ]);
    addTearDown(container.dispose);
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
    router.push(AppRoutes.imageCapture);
    await tester.pumpAndSettle();
  }

  testWidgets('取消选图：返回上一页', (tester) async {
    await pumpImageCapturePage(tester, pickedPaths: [null]);

    expect(find.byType(ImageCapturePage), findsNothing);
  });

  testWidgets('单码：直接替换为编辑页，码值与码制预填', (tester) async {
    await pumpImageCapturePage(
      tester,
      pickedPaths: ['/img/coupon.png'],
      analyzed: {
        '/img/coupon.png': const [
          ScanResult(value: '4006381333931', format: CodeFormat.ean13),
        ],
      },
    );

    // 与扫码同路径：相册页被替换，编辑页预填识别结果。
    expect(find.byType(ImageCapturePage), findsNothing);
    expect(find.text('Add card'), findsNWidgets(2));
    expect(find.text('4006381333931'), findsOneWidget);
    expect(find.text('EAN-13'), findsOneWidget);
  });

  testWidgets('识别失败：提示可能原因，可换图重试', (tester) async {
    await pumpImageCapturePage(
      tester,
      pickedPaths: ['/img/blurry.png', '/img/sharp.png'],
      analyzed: {
        '/img/sharp.png': const [
          ScanResult(value: 'RETRY-OK', format: CodeFormat.qrCode),
        ],
      },
    );

    expect(find.text('No code found'), findsOneWidget);
    expect(
      find.textContaining('enter the code manually'),
      findsOneWidget,
    );

    await tester.tap(find.text('Choose another image'));
    await tester.pumpAndSettle();

    expect(find.byType(ImageCapturePage), findsNothing);
    expect(find.text('RETRY-OK'), findsOneWidget);
  });

  testWidgets('识别失败：手动输入兜底进入空白编辑页', (tester) async {
    await pumpImageCapturePage(tester, pickedPaths: ['/img/blurry.png']);

    await tester.tap(find.text('Enter code manually'));
    await tester.pumpAndSettle();

    expect(find.byType(ImageCapturePage), findsNothing);
    expect(find.text('Add card'), findsNWidgets(2));
  });

  testWidgets('一图多码：候选列表（码值 + 码制），选中后预填编辑页',
      (tester) async {
    await pumpImageCapturePage(
      tester,
      pickedPaths: ['/img/two-codes.png'],
      analyzed: {
        '/img/two-codes.png': const [
          ScanResult(value: 'coupon-qr', format: CodeFormat.qrCode),
          ScanResult(value: '4006381333931', format: CodeFormat.ean13),
        ],
      },
    );

    // 两个候选都以 码值 + 码制 呈现。
    expect(find.text('coupon-qr'), findsOneWidget);
    expect(find.text('QR Code'), findsOneWidget);
    expect(find.text('4006381333931'), findsOneWidget);
    expect(find.text('EAN-13'), findsOneWidget);

    await tester.tap(find.text('4006381333931'));
    await tester.pumpAndSettle();

    expect(find.byType(ImageCapturePage), findsNothing);
    expect(find.text('Add card'), findsNWidgets(2));
    expect(find.text('4006381333931'), findsOneWidget);
    expect(find.text('EAN-13'), findsOneWidget);
  });
}
