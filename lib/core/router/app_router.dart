import 'package:go_router/go_router.dart';

import '../../features/auth/login_page.dart';
import '../../features/content/content_detail_page.dart';
import '../../features/content/content_page.dart';
import '../../features/content/create_content_page.dart';
import '../../features/content/edit_content_page.dart';
import '../../features/dashboard/home_page.dart';
import '../../shared/widgets/widget_showcase_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/showcase',
      builder: (context, state) => const WidgetShowcasePage(),
    ),
    GoRoute(path: '/content', builder: (context, state) => const ContentPage()),
    GoRoute(
      path: '/content/create',
      builder: (context, state) => const CreateContentPage(),
    ),
    GoRoute(
      path: '/content/:id',
      builder: (context, state) {
        final contentId = state.pathParameters['id'] ?? '';

        return ContentDetailPage(contentId: contentId);
      },
    ),
    GoRoute(
      path: '/content/:id/edit',
      builder: (context, state) {
        final contentId = state.pathParameters['id'] ?? '';

        return EditContentPage(contentId: contentId);
      },
    ),
  ],
);
