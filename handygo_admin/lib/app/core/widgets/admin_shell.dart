import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handygo_admin/app/core/constants/colors.dart';
import 'package:handygo_admin/app/modules/dashboard/views/dashboard_view.dart';
import 'package:handygo_admin/app/modules/users/views/users_view.dart';
import 'package:handygo_admin/app/modules/workers/views/workers_view.dart';
import 'package:handygo_admin/app/modules/jobs/views/jobs_view.dart';
import 'package:handygo_admin/app/modules/analytics/views/analytics_view.dart';
import 'package:handygo_admin/app/modules/kyc/views/kyc_view.dart';
import 'package:handygo_admin/app/modules/settings/views/settings_view.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;
  bool _isCollapsed = false;

  final _pages = const [
    DashboardView(),
    UsersView(),
    WorkersView(),
    JobsView(),
    AnalyticsView(),
    KycView(),
    SettingsView(),
  ];

  final _navItems = const [
    _NavItem(Icons.dashboard_rounded, 'Dashboard'),
    _NavItem(Icons.people_rounded, 'Customers'),
    _NavItem(Icons.engineering_rounded, 'Workers'),
    _NavItem(Icons.work_rounded, 'Jobs'),
    _NavItem(Icons.analytics_rounded, 'Analytics'),
    _NavItem(Icons.verified_user_rounded, 'KYC Verification'),
    _NavItem(Icons.settings_rounded, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AdminColors.background,
      drawer: isDesktop ? null : _buildDrawer(),
      body: Stack(
        children: [
          // Background ambient glow blobs
          Positioned(top: -200, right: -100, child: _ambientBlob(AdminColors.primary.withOpacity(0.04), 400)),
          Positioned(bottom: -150, left: 100, child: _ambientBlob(AdminColors.accent.withOpacity(0.03), 350)),
          Row(
            children: [
              if (isDesktop) _buildGlassSidebar(),
              Expanded(
                child: Column(
                  children: [
                    _buildGlassTopBar(isDesktop),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _pages[_selectedIndex],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _ambientBlob(Color color, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }

  Widget _buildGlassSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: _isCollapsed ? 80 : 260,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
              color: AdminColors.surface.withOpacity(0.8),
              border: Border(right: BorderSide(color: AdminColors.borderDark.withOpacity(0.5))),
            ),
            child: Column(
              children: [
                _buildLogo(),
                Divider(color: AdminColors.borderDark.withOpacity(0.3), height: 1),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    itemCount: _navItems.length,
                    itemBuilder: (context, index) => _buildNavItem(index),
                  ),
                ),
                Divider(color: AdminColors.borderDark.withOpacity(0.3), height: 1),
                _buildCollapseBtn(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [AdminColors.primary, AdminColors.primary.withOpacity(0.7)]),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(color: AdminColors.primary.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4))],
            ),
            child: const Icon(Icons.handyman_rounded, color: Colors.white, size: 24),
          ),
          if (!_isCollapsed) ...[
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('HandyGo', style: TextStyle(color: AdminColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Admin Portal', style: TextStyle(color: AdminColors.primary, fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ]
        ],
      ),
    );
  }

  Widget _buildNavItem(int index) {
    final item = _navItems[index];
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: _isCollapsed ? 12 : 16, vertical: 2),
        padding: EdgeInsets.symmetric(horizontal: _isCollapsed ? 0 : 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AdminColors.primary.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? Border.all(color: AdminColors.primary.withOpacity(0.2)) : null,
        ),
        child: Row(
          mainAxisAlignment: _isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(item.icon, color: isSelected ? AdminColors.primary : AdminColors.textSecondary, size: 22),
            if (!_isCollapsed) ...[
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(color: isSelected ? AdminColors.primary : AdminColors.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.w500, fontSize: 14),
                ),
              ),
              if (index == 5)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AdminColors.warning.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AdminColors.warning.withOpacity(0.3)),
                  ),
                  child: const Text('8', style: TextStyle(color: AdminColors.warning, fontSize: 11, fontWeight: FontWeight.bold)),
                ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildCollapseBtn() {
    return InkWell(
      onTap: () => setState(() => _isCollapsed = !_isCollapsed),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Icon(_isCollapsed ? Icons.chevron_right_rounded : Icons.chevron_left_rounded, color: AdminColors.textSecondary),
      ),
    );
  }

  Widget _buildGlassTopBar(bool isDesktop) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AdminColors.surface.withOpacity(0.7),
            border: Border(bottom: BorderSide(color: AdminColors.borderDark.withOpacity(0.4))),
          ),
          child: Row(
            children: [
              if (!isDesktop)
                IconButton(onPressed: () => _scaffoldKey.currentState?.openDrawer(), icon: const Icon(Icons.menu_rounded, color: AdminColors.textSecondary)),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.04),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AdminColors.borderDark.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search_rounded, color: AdminColors.textSecondary, size: 18),
                      const SizedBox(width: 8),
                      if (isDesktop) const Text('Search anything...', style: TextStyle(color: AdminColors.textSecondary, fontSize: 13)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.04), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.notifications_none_rounded, color: AdminColors.textSecondary, size: 20),
                  ),
                  Positioned(right: 6, top: 6, child: Container(width: 8, height: 8, decoration: const BoxDecoration(color: AdminColors.error, shape: BoxShape.circle))),
                ],
              ),
              const SizedBox(width: 12),
              Container(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 12 : 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AdminColors.borderDark.withOpacity(0.4)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28, height: 28,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [AdminColors.primary, AdminColors.accent]),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Center(child: Text('A', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold))),
                    ),
                    if (isDesktop) ...[
                      const SizedBox(width: 8),
                      const Text('Admin', style: TextStyle(color: AdminColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                      const SizedBox(width: 4),
                    ],
                    const Icon(Icons.keyboard_arrow_down_rounded, color: AdminColors.textSecondary, size: 18),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: AdminColors.surface,
      child: Column(
        children: [
          _buildLogo(),
          const Divider(color: AdminColors.borderDark),
          Expanded(
            child: ListView.builder(
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                final isSelected = _selectedIndex == index;
                return ListTile(
                  leading: Icon(item.icon, color: isSelected ? AdminColors.primary : AdminColors.textSecondary),
                  title: Text(item.label, style: TextStyle(color: isSelected ? AdminColors.primary : AdminColors.textSecondary)),
                  selected: isSelected,
                  onTap: () {
                    setState(() => _selectedIndex = index);
                    Navigator.pop(context);
                  },
                );
              },
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
