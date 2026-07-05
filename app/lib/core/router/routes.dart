/// 路由路径常量。
abstract final class AppRoutes {
  static const wallet = '/wallet';
  static const friends = '/friends';
  static const settings = '/settings';

  /// 新建卡编辑页。扫码/相册/手动入口（M1-03/04/05）经查询参数预填：
  /// `?value=<码值>&format=<CodeFormat.wire>`。
  static const cardNew = '/card/new';

  static String cardNewPrefilled(String value, String formatWire) =>
      Uri(path: cardNew, queryParameters: {
        'value': value,
        'format': formatWire,
      }).toString();

  static String cardEdit(String id) => '/card/$id/edit';
}
