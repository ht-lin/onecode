# features/capture/

录入域：扫码、相册识别、手动录入（SPEC §3.1/§5.3）。

- `domain/` — `ScanResult`（识别结果）、`ScanGate`（同码 2s 防抖），纯 Dart。
- `data/` — mobile_scanner 码制 ↔ `CodeFormat` 映射；`CameraPermissionService`
  权限抽象（permission_handler 实现，测试 fake 覆写 provider）。
- `presentation/` — `ScanPage`（权限分支 + 识别确认流程，M1-03）、
  `ScannerView`（实时取景 + 识别框遮罩 + 手电筒；经
  `scannerViewBuilderProvider` 注入，widget 测试可 mock）。

待补：相册识别（M1-04）、手动录入入口页（M1-05，编辑页即表单）。
