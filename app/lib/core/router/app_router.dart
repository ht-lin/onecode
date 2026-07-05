import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/drift/enums.dart';
import '../../features/account/presentation/settings_page.dart';
import '../../features/card_editor/presentation/card_editor_page.dart';
import '../../features/friends/presentation/friends_page.dart';
import '../../features/wallet/presentation/wallet_page.dart';
import 'app_shell.dart';
import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) => GoRouter(
      initialLocation: AppRoutes.wallet,
      routes: [
        // 编辑页在根导航器上（全屏盖过底部 Tab 栏）。
        GoRoute(
          path: AppRoutes.cardNew,
          builder: (context, state) {
            final params = state.uri.queryParameters;
            final formatWire = params['format'];
            return CardEditorPage(
              initialCodeValue: params['value'],
              initialCodeFormat: CodeFormat.values
                  .where((f) => f.wire == formatWire)
                  .firstOrNull,
            );
          },
        ),
        GoRoute(
          path: '/card/:id/edit',
          builder: (context, state) =>
              CardEditorPage(cardId: state.pathParameters['id']!),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              AppShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.wallet,
                  builder: (context, state) => const WalletPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.friends,
                  builder: (context, state) => const FriendsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRoutes.settings,
                  builder: (context, state) => const SettingsPage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
