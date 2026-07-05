# OneCode App

Flutter 客户端（iOS 15+ / Android 8.0+，API 26）。
技术栈：Flutter 3.44 stable · Riverpod 3（codegen）· go_router · Material 3 · gen_l10n（de/en）。

## 快速开始

```bash
cd app
flutter pub get     # 同时触发 gen-l10n（pubspec 中 generate: true）
flutter run         # 需要已连接的模拟器/真机
```

## 常用命令

```bash
flutter gen-l10n                                           # 重新生成 l10n（改 .arb 后）
dart run build_runner build --delete-conflicting-outputs   # 重新生成 Riverpod 代码（*.g.dart）
flutter analyze                                            # 静态检查，门禁：零告警
flutter test                                               # widget 测试
flutter build apk --debug                                  # Android 编译验证
```

生成代码（`*.g.dart`、`lib/l10n/app_localizations*.dart`）**提交入库**：
`flutter analyze` 不会自动触发生成，入库后 CI 无需生成步骤。改动 `.arb` 或 `@riverpod` 后记得重新生成并一并提交。

## 目录结构（SPEC §5.3，feature-first）

```
lib/
  core/       # 主题（含 12 色卡面色板）、路由(go_router)、工具
  data/       # Drift 表/DAO(→M1-01)、API client(→M2-06)、SyncEngine(→M2-07)
  l10n/       # ARB(de/en) + 生成的 AppLocalizations
  features/
    wallet/   # 卡包（M1）
    capture/  # 扫码/识别/录入（M1）
    friends/  # 好友（M3）
    sharing/  # 共享（M3）
    account/  # 登录/设置/法务（M2）
```

## i18n 约定

- 模板语言 **en**（`lib/l10n/app_en.arb`，含 `@` 描述），`app_de.arb` 为德语翻译。
- 语言跟随系统（SPEC §3.9 的应用内语言设置在 M2 实现）。

## org 占位改名 checklist（Q1 品牌定案后）

当前 bundle id / applicationId 为占位 **`de.onecode.onecode`**。改名需同步：

- [ ] `android/app/build.gradle.kts` — `namespace` + `applicationId`
- [ ] `android/app/src/main/kotlin/de/onecode/onecode/MainActivity.kt` — 包路径与 package 声明
- [ ] `ios/Runner.xcodeproj/project.pbxproj` — `PRODUCT_BUNDLE_IDENTIFIER`（Runner 3 处 + RunnerTests 3 处）
- [ ] 显示名如变：`AndroidManifest.xml` 的 `android:label`、`ios/Runner/Info.plist` 的 `CFBundleDisplayName`

## 平台说明

- 最低版本：Android `minSdk 26`（`build.gradle.kts`）、iOS 15（`project.pbxproj` 的 `IPHONEOS_DEPLOYMENT_TARGET`，3 处）。
- iOS 依赖走 **Swift Package Manager**（Flutter 3.44 默认，无 Podfile）。若日后回退 CocoaPods 生成了 Podfile，需设 `platform :ios, '15.0'` 并提交。
