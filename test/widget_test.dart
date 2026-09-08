import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_starter/presentation/pages/books.dart';
import 'package:flutter_starter/presentation/pages/home.dart';
import 'package:flutter_starter/presentation/pages/profile.dart';
import 'package:flutter_starter/presentation/pages/settings.dart';
import 'package:flutter_starter/presentation/theme/theme.dart';
import 'package:flutter_starter/presentation/widgets/nav.dart';

Widget _buildTestApp({
  required Widget child,
  String currentPath = '/',
  ThemeData? theme,
}) {
  return ProviderScope(
    child: MaterialApp(
      theme: theme ??
          AppTheme.lightTheme.copyWith(
            extensions: [AppThemeExtension.light],
          ),
      home: AppBaseLayout(
        currentPath: currentPath,
        child: child,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Responsive AppBaseLayout tests', () {
    testWidgets(
      'renders AppBottomNavigation on small screens (< 640dp)',
      (WidgetTester tester) async {
        // Set physical size to a mobile width (400 x 800)
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: Text('Content on Mobile')),
          ),
        );
        await tester.pumpAndSettle();

        // Bottom navigation should be present
        expect(find.byType(AppBottomNavigation), findsOneWidget);
        expect(find.byType(NavigationBar), findsOneWidget);
        // Side navigation should not be present
        expect(find.byType(AppSideNavigation), findsNothing);
        expect(find.byType(NavigationRail), findsNothing);

        // Verify all 4 labels are present in bottom nav
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Books'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
      },
    );

    testWidgets(
      'renders AppSideNavigation on large screens (>= 640dp)',
      (WidgetTester tester) async {
        // Set physical size to desktop width (1200 x 800)
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: Text('Content on Desktop')),
          ),
        );
        await tester.pumpAndSettle();

        // Side navigation should be present
        expect(find.byType(AppSideNavigation), findsOneWidget);
        expect(find.byType(NavigationRail), findsOneWidget);
        // Bottom navigation should not be present
        expect(find.byType(AppBottomNavigation), findsNothing);
        expect(find.byType(NavigationBar), findsNothing);

        // Verify branding and destinations
        expect(find.text('Starter App'), findsOneWidget);
        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Books'), findsOneWidget);
        expect(find.text('Profile'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
      },
    );

    testWidgets(
      'switches automatically between bottom nav and side nav on resize',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(500, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: Text('Resizable Content')),
          ),
        );
        await tester.pumpAndSettle();

        // Initially mobile
        expect(find.byType(AppBottomNavigation), findsOneWidget);
        expect(find.byType(AppSideNavigation), findsNothing);

        // Resize to desktop width
        tester.view.physicalSize = const Size(900, 800);
        await tester.pumpAndSettle();

        // Now desktop
        expect(find.byType(AppBottomNavigation), findsNothing);
        expect(find.byType(AppSideNavigation), findsOneWidget);

        // Resize back to mobile width
        tester.view.physicalSize = const Size(400, 800);
        await tester.pumpAndSettle();

        // Back to mobile
        expect(find.byType(AppBottomNavigation), findsOneWidget);
        expect(find.byType(AppSideNavigation), findsNothing);
      },
    );

    testWidgets(
      'nav items have accessible icons, labels, and tooltips',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1200, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildTestApp(
            child: const Scaffold(body: Text('Accessible Nav')),
          ),
        );
        await tester.pumpAndSettle();

        // Verify side navigation and destinations exist
        expect(find.byType(AppSideNavigation), findsOneWidget);

        // Verify tooltips for all navigation items
        expect(find.byTooltip('Navigate to Home'), findsOneWidget);
        expect(find.byTooltip('Navigate to Books'), findsOneWidget);
        expect(find.byTooltip('Navigate to Profile'), findsOneWidget);
        expect(find.byTooltip('Navigate to Settings'), findsOneWidget);

        // Verify tooltips for footer actions
        expect(find.byTooltip('Collapse sidebar'), findsOneWidget);
        expect(find.byTooltip('Switch to Dark Mode'), findsOneWidget);

        // Icons are present
        expect(find.byIcon(Icons.home_outlined), findsNothing); // selected
        expect(find.byIcon(Icons.home_rounded), findsOneWidget); // selected home
        expect(find.byIcon(Icons.menu_book_outlined), findsOneWidget);
        expect(find.byIcon(Icons.person_outline_rounded), findsOneWidget);
        expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      },
    );

    testWidgets(
      'nav selection updates based on currentPath',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(400, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildTestApp(
            currentPath: '/books',
            child: const Scaffold(body: Text('Books Content')),
          ),
        );
        await tester.pumpAndSettle();

        final navBar = tester.widget<NavigationBar>(find.byType(NavigationBar));
        expect(navBar.selectedIndex, equals(1));
      },
    );

    testWidgets(
      'renders correctly with dark theme',
      (WidgetTester tester) async {
        tester.view.physicalSize = const Size(1000, 800);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          _buildTestApp(
            theme: AppTheme.darkTheme.copyWith(
              extensions: [AppThemeExtension.dark],
            ),
            child: const Scaffold(body: Text('Dark Theme Shell')),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AppSideNavigation), findsOneWidget);
        final sideNavContainer = tester.widget<Container>(
          find.descendant(
            of: find.byType(AppSideNavigation),
            matching: find.byType(Container).first,
          ),
        );
        expect(sideNavContainer.color, equals(BrandColors.darkGrey));
      },
    );
  });

  group('Simple Nav Pages render properly', () {
    testWidgets('HomePage renders and has quick navigation', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: HomePage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Home'), findsOneWidget);
      expect(find.text('Flutter Starter Template'), findsOneWidget);
      expect(find.text('Books'), findsOneWidget);
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('BooksPage renders with library items and filter chips', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: BooksPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Books'), findsOneWidget);
      expect(find.text('Your Reading Library'), findsOneWidget);
      expect(find.text('Clean Code'), findsOneWidget);
      expect(find.text('The Pragmatic Programmer'), findsOneWidget);
      expect(find.text('All'), findsOneWidget);
      expect(find.text('Engineering'), findsOneWidget);
    });

    testWidgets('ProfilePage renders user card and sign out option', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: ProfilePage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Jane Doe'), findsOneWidget);
      expect(find.text('jane.doe@example.com'), findsOneWidget);

      await tester.scrollUntilVisible(find.text('Sign Out'), 100);
      expect(find.text('Sign Out'), findsOneWidget);
    });

    testWidgets('SettingsPage renders sections and switches', (tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(home: SettingsPage()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(find.text('About Application'), findsOneWidget);
    });
  });
}
