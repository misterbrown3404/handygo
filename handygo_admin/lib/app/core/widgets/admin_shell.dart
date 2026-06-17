import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:handygo_admin/core/colors/admin_colors.dart';
import 'package:handygo_admin/app/modules/dashboard/views/dashboard_view.dart';
import 'package:handygo_admin/app/modules/users/views/users_view.dart';
import 'package:handygo_admin/app/modules/workers/views/workers_view.dart';
import 'package:handygo_admin/app/modules/jobs/views/jobs_view.dart';
import 'package:handygo_admin/app/modules/analytics/views/analytics_view.dart';
import 'package:handygo_admin/app/modules/kyc/views/kyc_view.dart';
import 'package:handygo_admin/app/modules/settings/views/settings_view.dart';
import 'package:handygo_admin/app/modules/services/views/services_view.dart';
import 'package:handygo_admin/app/modules/notifications/views/notifications_view.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool _isSidebarCollapsed = false;

  // ── Desktop sidebar liquid animation ──────────────────────────
  late final AnimationController _sidebarAnim;
  late final Animation<double> _sidebarWidth;
  late final AnimationController _itemStaggerAnim;

  // ── Mobile drawer liquid animation ────────────────────────────
  late final AnimationController _drawerSlideAnim;
  late final AnimationController _drawerFadeAnim;

  static const _allPages = [
    DashboardView(),
    UsersView(),
    WorkersView(),
    ServicesAdminView(),
    JobsView(),
    AnalyticsView(),
    KycView(),
    NotificationsView(),
    SettingsView(),
  ];

  static const _navItems = [
    _NavItem(Icons.dashboard_rounded, 'Dashboard'),
    _NavItem(Icons.people_rounded, 'Customers'),
    _NavItem(Icons.engineering_rounded, 'Workers'),
    _NavItem(Icons.category_rounded, 'Services'),
    _NavItem(Icons.work_rounded, 'Jobs'),
    _NavItem(Icons.analytics_rounded, 'Analytics'),
    _NavItem(Icons.verified_user_rounded, 'KYC Verification'),
    _NavItem(Icons.notifications_rounded, 'Notifications'),
    _NavItem(Icons.settings_rounded, 'Settings'),
  ];

  @override
  void initState() {
    super.initState();
    _sidebarAnim = AnimationController(
      duration: const Duration(milliseconds: 420),
      vsync: this,
    );
    _sidebarWidth = CurvedAnimation(
      parent: _sidebarAnim,
      curve: Curves.easeOutQuart,
    );
    _itemStaggerAnim = AnimationController(
      duration: const Duration(milliseconds: 260),
      vsync: this,
    );
    // Mobile drawer
    _drawerSlideAnim = AnimationController(
      duration: const Duration(milliseconds: 360),
      vsync: this,
    );
    _drawerFadeAnim = AnimationController(
      duration: const Duration(milliseconds: 240),
      vsync: this,
    );
    // Start at the right value
    _sidebarAnim.value = _isSidebarCollapsed ? 0.0 : 1.0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isDesktop = MediaQuery.of(context).size.width > 768;
    if (!isDesktop) {
      _drawerSlideAnim.reset();
      _drawerFadeAnim.reset();
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarCollapsed = !_isSidebarCollapsed;
    });
    if (_isSidebarCollapsed) {
      _sidebarAnim.reverse();
      _itemStaggerAnim.reverse();
    } else {
      _sidebarAnim.forward();
      // Stagger children after the sidebar is halfway open
      Future.delayed(const Duration(milliseconds: 120))
          .then((_) => _itemStaggerAnim.forward());
    }
  }

  void _openMobileDrawer() {
    _scaffoldKey.currentState?.openDrawer();
    _drawerSlideAnim.forward(from: 0.0);
    _drawerFadeAnim.forward(from: 0.0);
  }

  void _closeMobileDrawer() {
    _drawerSlideAnim.reverse();
    _drawerFadeAnim.reverse();
  }

  @override
  void dispose() {
    _sidebarAnim.dispose();
    _itemStaggerAnim.dispose();
    _drawerSlideAnim.dispose();
    _drawerFadeAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AdminColors.background,
      drawer: isDesktop
          ? null
          : _buildLiquidMobileDrawer(context),
      body: SafeArea(
        child: Row(
          children: [
            if (isDesktop) _buildLiquidDesktopSidebar(),
            const VerticalDivider(thickness: 1, width: 1),
            Expanded(
              child: Column(
                children: [
                  _buildTopBar(isDesktop),
                  Expanded(
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 280),
                      transitionBuilder: (child, anim) =>
                          FadeTransition(opacity: anim, child: child),
                      child: _allPages[_selectedIndex],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  LIQUID DESKTOP SIDEBAR
  // ══════════════════════════════════════════════════════════════

  Widget _buildLiquidDesktopSidebar() {
    final collapsedWidth = 76.0;
    final expandedWidth = 260.0;

    return AnimatedBuilder(
      animation: Listenable.merge([_sidebarWidth, _itemStaggerAnim]),
      builder: (context, _) {
        final t = _sidebarWidth.value;
        // Liquid spring-width: interpolate from collapsed to expanded
        final currentWidth = collapsedWidth +
            (expandedWidth - collapsedWidth) * _easeOutExpo(t);
        // label opacity fades in from 0–0.55
        final labelAlpha = (t * 2).clamp(0.0, 1.0);
        // icon/logo shifts right as sidebar opens
        final iconShift = t * 8.0;

        return Container(
          width: currentWidth,
          decoration: const BoxDecoration(
            color: AdminColors.surface,
            border: Border(
              right: BorderSide(color: AdminColors.borderDark, width: 1),
            ),
          ),
          child: Column(
            crossAxisAlignment:
                _isSidebarCollapsed
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AdminSpacing.lg),
              // ── Logo ──────────────────────────────────────────────
              Padding(
                padding: EdgeInsets.only(left: iconShift),
                child: Row(
                  mainAxisSize: _isSidebarCollapsed
                      ? MainAxisSize.min
                      : MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AdminSpacing.sm),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AdminColors.primary, AdminColors.accent],
                        ),
                        borderRadius: BorderRadius.circular(AdminSpacing.sm),
                        boxShadow: [
                          BoxShadow(
                            color: AdminColors.primary.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.handyman_rounded,
                        color: AdminColors.white,
                        size: 22,
                      ),
                    ),
                    if (labelAlpha > 0.01) ...[
                      const SizedBox(width: AdminSpacing.sm),
                      Opacity(
                        opacity: labelAlpha,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'HandyGo',
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Admin Portal',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                color: AdminColors.accent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AdminSpacing.lg),
              Divider(
                height: 1,
                thickness: 1,
                color: AdminColors.borderDark.withValues(
                  alpha: 0.3 + 0.7 * labelAlpha,
                ),
              ),
              const SizedBox(height: AdminSpacing.sm),
              // ── Nav items ─────────────────────────────────────────
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AdminSpacing.sm,
                    vertical: AdminSpacing.sm,
                  ),
                  itemCount: _navItems.length,
                  itemBuilder: (context, index) {
                    return _buildLiquidNavItem(index, t, labelAlpha);
                  },
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: AdminColors.borderDark.withValues(
                  alpha: 0.3 + 0.7 * labelAlpha,
                ),
              ),
              _buildCollapseToggle(),
              const SizedBox(height: AdminSpacing.sm),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLiquidNavItem(int index, double t, double labelAlpha) {
    final item = _navItems[index];
    final isSelected = _selectedIndex == index;
    // Stagger: items near the top appear first
    final staggerDelay = (index * 0.045).clamp(0.0, 0.25);
    final staggerT = (t - staggerDelay).clamp(0.0, 1.0) / (1.0 - staggerDelay);
    final staggerAlpha = _easeOutCubic(staggerT);
    final showLabel = staggerAlpha > 0.1;

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 120),
      opacity: staggerAlpha,
      child: InkWell(
        onTap: () => setState(() => _selectedIndex = index),
        borderRadius: BorderRadius.circular(AdminSpacing.sm),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutQuart,
          margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 1),
          padding: EdgeInsets.symmetric(
            horizontal: showLabel ? AdminSpacing.sm : 0,
            vertical: AdminSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AdminColors.primary.withValues(alpha: 0.11)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AdminSpacing.sm),
            border: isSelected
                ? Border.all(
                    color: AdminColors.primary.withValues(alpha: 0.22),
                    width: 1.5,
                  )
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: showLabel
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                scale: isSelected ? 1.08 : 1.0,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? AdminColors.primary.withValues(alpha: 0.13)
                        : Colors.transparent,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: Badge(
                    isLabelVisible: index == 6 && !_isSidebarCollapsed,
                    backgroundColor: AdminColors.warning,
                    label: const Text(
                      '8',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    child: Icon(
                      item.icon,
                      color: isSelected
                          ? AdminColors.primary
                          : AdminColors.textSecondary,
                      size: 22,
                    ),
                  ),
                ),
              ),
              if (showLabel && staggerAlpha > 0.05) ...[
                const SizedBox(width: AdminSpacing.sm),
                Flexible(
                  child: Opacity(
                    opacity: staggerAlpha,
                    child: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AdminColors.primary
                            : AdminColors.textSecondary,
                        fontSize: 13,
                        letterSpacing: 0.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // ── Collapse toggle button ───────────────────────────────────

  Widget _buildCollapseToggle() {
    return InkWell(
      onTap: _toggleSidebar,
      borderRadius: BorderRadius.circular(AdminSpacing.sm),
      child: Padding(
        padding: const EdgeInsets.all(AdminSpacing.sm),
        child: AnimatedRotation(
          duration: const Duration(milliseconds: 240),
          turns: _isSidebarCollapsed ? 0.5 : 0.0,
          child: Icon(
            Icons.chevron_left_rounded,
            color: AdminColors.textSecondary,
            size: 18,
          ),
        ),
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  LIQUID MOBILE DRAWER
  // ══════════════════════════════════════════════════════════════

  Widget _buildLiquidMobileDrawer(BuildContext context) {
    final drawerWidth = MediaQuery.of(context).size.width * 0.82;
    return Stack(
      children: [
        // ── Backdrop overlay ────────────────────────────────────
        AnimatedBuilder(
          animation: _drawerFadeAnim,
          builder: (context, _) {
            final alpha = _drawerFadeAnim.value * 0.32;
            return GestureDetector(
              onTap: _closeMobileDrawer,
              child: Container(
                color: AdminColors.neutral900.withValues(alpha: alpha),
              ),
            );
          },
        ),
        // ── Drawer panel ───────────────────────────────────────
        AnimatedBuilder(
          animation: Listenable.merge([
            _drawerSlideAnim,
            _drawerFadeAnim,
          ]),
          builder: (context, _) {
            // Spring-like slide from left
            final slideX = (1.0 - Curves.fastOutSlowIn.transform(
              _drawerSlideAnim.value,
            )) *
                -drawerWidth;

            return Transform.translate(
              offset: Offset(slideX, 0),
              child: Container(
                width: drawerWidth,
                decoration: const BoxDecoration(
                  color: AdminColors.surface,
                ),
                child: Column(
                  children: [
                    // Header
                    SafeArea(
                      bottom: false,
                      child: Container(
                        padding: const EdgeInsets.all(AdminSpacing.lg),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AdminColors.primary, AdminColors.primaryDark],
                          ),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(28),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.18),
                                    borderRadius: BorderRadius.circular(
                                      AdminSpacing.sm,
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.handyman_rounded,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: AdminSpacing.sm),
                                const Text(
                                  'HandyGo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: _closeMobileDrawer,
                              icon: const Icon(
                                Icons.close_rounded,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Nav list
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          vertical: AdminSpacing.md,
                        ),
                        itemCount: _navItems.length,
                        itemBuilder: (context, index) {
                          final item = _navItems[index];
                          final isSelected = _selectedIndex == index;
                          // Stagger item reveal as drawer slides open
                          final staggerDelay = (index * 0.05).clamp(0.0, 0.4);
                          final raw =
                              1.0 -
                              (_drawerSlideAnim.value - staggerDelay)
                                  .clamp(0.0, 1.0);
                          final itemOpacity = _easeOutCubic(raw);
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 80),
                            opacity: itemOpacity,
                            child: ListTile(
                              leading: Icon(
                                item.icon,
                                color: isSelected
                                    ? AdminColors.primary
                                    : AdminColors.textSecondary,
                              ),
                              title: Text(
                                item.label,
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AdminColors.primary
                                      : AdminColors.textSecondary,
                                ),
                              ),
                              selected: isSelected,
                              selectedTileColor: AdminColors.primaryLight,
                              onTap: () {
                                setState(() => _selectedIndex = index);
                                _drawerSlideAnim.reverse();
                                _drawerFadeAnim.reverse();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    // Footer
                    Padding(
                      padding: const EdgeInsets.all(AdminSpacing.lg),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [AdminColors.primary, AdminColors.accent],
                              ),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Center(
                              child: Text(
                                'A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AdminSpacing.sm),
                          const Expanded(
                            child: Text(
                              'Admin',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: AdminColors.textPrimary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: _closeMobileDrawer,
                            child: const Text('Logout'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // ══════════════════════════════════════════════════════════════
  //  TOP BAR
  // ══════════════════════════════════════════════════════════════

  Widget _buildTopBar(bool isDesktop) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.md),
      decoration: const BoxDecoration(
        color: AdminColors.surface,
        border: Border(
          bottom: BorderSide(color: AdminColors.borderDark, width: 1),
        ),
      ),
      child: Row(
        children: [
          if (!isDesktop)
            IconButton(
              onPressed: _openMobileDrawer,
              icon: const Icon(
                Icons.menu_rounded,
                color: AdminColors.textSecondary,
              ),
            ),
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: AdminSpacing.sm),
              decoration: BoxDecoration(
                color: AdminColors.neutral100,
                borderRadius: BorderRadius.circular(AdminSpacing.sm),
                border: Border.all(color: AdminColors.borderDark, width: 1),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: AdminColors.textSecondary,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Search anything\u2026',
                      style: TextStyle(
                        color: AdminColors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(
                    Icons.tune_rounded,
                    color: AdminColors.textSecondary,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: AdminSpacing.sm),
          Stack(
            children: [
              Material(
                color: AdminColors.neutral100,
                borderRadius: BorderRadius.circular(AdminSpacing.sm),
                child: const Padding(
                  padding: EdgeInsets.all(AdminSpacing.sm),
                  child: Icon(
                    Icons.notifications_none_rounded,
                    color: AdminColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
              Positioned(
                right: 5,
                top: 5,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AdminColors.danger,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AdminSpacing.sm),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? AdminSpacing.sm : AdminSpacing.xs,
              vertical: AdminSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AdminColors.neutral100,
              border: Border.all(color: AdminColors.borderDark, width: 1),
              borderRadius: BorderRadius.circular(AdminSpacing.sm),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AdminColors.primary, AdminColors.accent],
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: const Center(
                    child: Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 8),
                  const Text(
                    'Admin',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AdminColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 2),
                ],
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AdminColors.textSecondary,
                  size: 18,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem(this.icon, this.label);
}

// ══════════════════════════════════════════════════════════════════
//  Math helpers
// ══════════════════════════════════════════════════════════════════

/// Smooth ease-out — liquid feel. Equivalent to `easeOutExpo`.
double _easeOutExpo(double t) =>
    t == 0.0
        ? 0.0
        : t == 1.0
            ? 1.0
            : 1.0 - math.pow(2.0, -10.0 * t);

/// Cubic ease-out for staggered child reveals.
double _easeOutCubic(double t) =>
    t == 1.0
        ? 1.0
        : 1.0 - math.pow(1.0 - t, 3.0);
