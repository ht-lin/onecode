import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/drift/enums.dart';
import '../../features/account/presentation/settings_page.dart';
import '../../features/capture/presentation/image_capture_page.dart';
import '../../features/capture/presentation/scan_page.dart';
import '../../features/card_display/presentation/card_display_page.dart';
import '../../features/card_editor/presentation/card_editor_page.dart';
import '../../features/friends/presentation/friends_page.dart';
import '../../features/legal/presentation/legal_page.dart';
import '../../features/wallet/presentation/wallet_page.dart';
import '../../l10n/app_localizations.dart';
import 'app_shell.dart';
import 'routes.dart';

part 'app_router.g.dart';

@riverpod
GoRouter appRouter(Ref ref) => GoRouter(
      initialLocation: AppRoutes.wallet,
      routes: [
        // 录入/编辑页在根导航器上（全屏盖过底部 Tab 栏）。
        GoRoute(
          path: AppRoutes.scan,
          builder: (context, state) => const ScanPage(),
        ),
        GoRoute(
          path: AppRoutes.imageCapture,
          builder: (context, state) => const ImageCapturePage(),
        ),
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
        // 字面段 /card/new 优先于参数段匹配，不会被 :id 吞掉。
        GoRoute(
          path: '/card/:id',
          builder: (context, state) =>
              CardDisplayPage(cardId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: AppRoutes.impressum,
          builder: (context, state) => LegalPage(
            title: AppLocalizations.of(context).legalImpressum,
            sections: impressumSections,
          ),
        ),
        GoRoute(
          path: AppRoutes.privacy,
          builder: (context, state) => LegalPage(
            title: AppLocalizations.of(context).legalPrivacy,
            sections: privacySections,
          ),
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
