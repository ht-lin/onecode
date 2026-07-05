import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/account/presentation/settings_page.dart';
import '../../features/friends/presentation/friends_page.dart';
import '../../features/wallet/presentation/wallet_page.dart';
import 'app_shell.dart';
import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) => GoRouter(
      initialLocation: AppRoutes.wallet,
      routes: [
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
