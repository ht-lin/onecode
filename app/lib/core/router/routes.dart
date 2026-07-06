/// 路由路径常量。
abstract final class AppRoutes {
  static const wallet = '/wallet';
  static const friends = '/friends';
  static const settings = '/settings';

  /// 摄像头扫码录入页（M1-03），识别确认后替换为 [cardNew] 预填。
  static const scan = '/scan';

  /// 相册图片识别录入页（M1-04），识别成功后替换为 [cardNew] 预填。
  static const imageCapture = '/scan/image';

  /// 新建卡编辑页。扫码/相册/手动入口（M1-03/04/05）经查询参数预填：
  /// `?value=<码值>&format=<CodeFormat.wire>`。
  static const cardNew = '/card/new';

  static String cardNewPrefilled(String value, String formatWire) =>
      Uri(path: cardNew, queryParameters: {
        'value': value,
        'format': formatWire,
      }).toString();

  static String cardEdit(String id) => '/card/$id/edit';

  /// 卡片展示页（M1-07，SPEC §3.4）：点卡面直达，收银台性能关键路径。
  static String cardDisplay(String id) => '/card/$id';

  /// 法务页（M1-09，SPEC §9.3），从设置进入。
  static const impressum = '/legal/impressum';
  static const privacy = '/legal/privacy';
}
