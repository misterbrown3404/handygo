# HandyGo — Complete Project Documentation

> **Last Updated:** May 10, 2026  
> **Author:** Senior Flutter Architect  
> **Purpose:** This document provides full context for any AI assistant or developer to continue work on the HandyGo ecosystem without loss of architectural intent, design decisions, or implementation details.

---

## 1. Project Overview

**HandyGo** is a Nigerian home-services marketplace (similar to TaskRabbit/Thumbtack) connecting **Customers** with verified **Service Workers** (Plumbers, Electricians, Cleaners, AC Technicians, Carpenters). The platform consists of **three standalone Flutter applications** sharing a unified design language and business logic architecture.

### Applications

| App | Type | Directory | Platform | Status |
|-----|------|-----------|----------|--------|
| **handygo** | Customer App | `/handygo/` | iOS & Android | ✅ Production-ready frontend |
| **handygo_worker** | Worker App | `/handygo_worker/` | iOS & Android | ✅ Production-ready frontend |
| **handygo_admin** | Admin Portal | `/handygo_admin/` | Web (Flutter Web) | ✅ Production-ready frontend |

### Workspace Root
```
/Users/annur-dev/Flutter-work/handyGo/
├── handygo/              # Customer-facing mobile app
├── handygo_worker/       # Worker/Provider mobile app
├── handygo_admin/        # Admin web dashboard
└── HANDYGO_PROJECT_CONTEXT.md  # This file
```

---

## 2. Technology Stack

| Layer | Technology | Version |
|-------|-----------|---------|
| Framework | Flutter | Latest stable |
| State Management | GetX (`get`) | 4.7.3 |
| Charts (Admin) | `fl_chart` | 1.2.0 |
| Fonts (Admin) | `google_fonts` | Latest |
| Fonts (Mobile) | Poppins (bundled in assets) | — |
| Architecture | GetX Modular (MVVM-like) | — |
| Navigation | GetX Named Routes + Bindings | — |
| Backend | **Not yet connected** (frontend-only) | — |

---

## 3. Shared Design System

### 3.1 Brand Colors
```dart
Primary Green:    #55B436  (used across all 3 apps)
Primary Dark:     #2E7D32
Accent Cyan:      #4FC3F7  (admin accents)
Background Dark:  #0F1117  (admin only)
Surface Dark:     #1A1D27  (admin only)
```

### 3.2 Typography
- **Mobile Apps**: Poppins (bundled in `assets/fonts/`)
- **Admin Portal**: Inter (via `google_fonts`)

### 3.3 Design Tokens (Mobile)
```dart
// lib/app/core/constant/spacing.dart
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
}
```

### 3.4 UI Aesthetic: Glassmorphism
All three apps use **Glassmorphism** as the primary visual language:
- `BackdropFilter` with `ImageFilter.blur(sigmaX, sigmaY)` 
- Semi-transparent white/dark fills (`Colors.white.withOpacity(0.1–0.15)`)
- Frosted borders (`Border.all(color: Colors.white.withOpacity(0.2))`)
- Subtle gradient overlays (`LinearGradient` from top-left to bottom-right)
- Ambient glow blobs positioned behind content for depth

**Performance Note:** Glassmorphism uses GPU-intensive blur. It is applied strategically — on static cards and headers, NOT on scrollable list items in production. The mobile apps use a "balanced" approach where list items use solid cards with soft shadows instead.

---

## 4. Customer App (`handygo/`)

### Purpose
Allows Nigerian customers to browse, book, and pay for home services.

### Key Modules
| Module | Path | Features |
|--------|------|----------|
| Splash | `/modules/splash/` | Animated brand intro |
| Home | `/modules/home/` | Service browsing, search, floating bottom nav |
| Service Detail | `/modules/service_detail/` | Provider profiles, reviews, stats, booking CTA |
| Bookings | `/modules/bookings/` | Booking form, room selection, e-receipt |
| Chat | `/modules/chat/` | Customer ↔ Worker messaging |
| Favourites | `/modules/favourites/` | Saved service providers |
| Profile | `/modules/profile/` | Account settings, sign-out |

### Assets
```
assets/
├── images/
│   ├── home_image.jpg, home_image_2.jpg, home_image_3.jpg
│   ├── onboarding.jpg, onboarding_2.jpg
│   ├── profile.jpg
│   ├── favourite.jpg, favourite_2.jpg, favourite_3.jpg
│   ├── facebook.jpg, google.jpg
│   └── (shared across worker app)
├── fonts/
│   └── Poppins/ (Regular, Medium, SemiBold, Bold)
└── Ui/
    └── (UI mockup images)
```

---

## 5. Worker App (`handygo_worker/`)

### Purpose
Allows verified workers to receive job alerts, manage bookings, communicate with customers, track earnings, and complete service jobs.

### Architecture Pattern
```
lib/app/
├── core/
│   ├── bindings/
│   │   └── initial_binding.dart     # Global controller injection (permanent)
│   ├── constant/
│   │   ├── color.dart               # AppColors (primaryColor: #55B436)
│   │   └── spacing.dart             # AppSpacing design tokens
│   └── theme/
│       └── theme.dart               # workerTheme() — Poppins, light mode
├── data/
│   └── models/
│       ├── job_request_model.dart    # id, customerName, serviceType, location, price, status
│       └── chat_model.dart
├── modules/
│   ├── auth/        → Login, Signup, KYC (NIN/BVN), Onboarding
│   ├── main/        → Navigation shell with bottom nav bar
│   ├── dashboard/   → Worker home: stats, status toggle, active jobs
│   ├── bookings/    → Job requests list, job status/completion flow
│   ├── chat/        → Chat list + individual chat with quick replies
│   ├── wallet/      → Earnings balance, transactions, withdrawal
│   └── profile/     → Glassmorphic profile with stats & settings
├── routes/
│   ├── app_routes.dart              # Named route constants
│   └── app_pages.dart               # Route → View + Binding mapping
└── widgets/
    ├── fade_in_animation.dart       # Reusable micro-animation wrapper
    ├── primary_button.dart          # Brand-styled CTA button
    └── job_alert_overlay.dart       # 30-second countdown job alert
```

### Navigation Flow
```
LoginView → SignupView → KycView → OnboardingView → MainView (Dashboard)
                                                       ├── Dashboard Tab
                                                       ├── Bookings Tab
                                                       ├── Chat Tab
                                                       ├── Wallet Tab
                                                       └── Profile Tab
```

### Key Engineering Decisions

#### 1. InitialBinding (Global Controllers)
```dart
// lib/app/core/bindings/initial_binding.dart
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MainController(), permanent: true);
    Get.put(DashboardController(), permanent: true);
    Get.put(BookingsController(), permanent: true);
    Get.put(ChatController(), permanent: true);
    Get.put(WalletController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
  }
}
```
**Why:** GetX `lazyPut` controllers were being disposed during tab switching, causing "Controller not found" crashes. Setting them as `permanent: true` in a global binding ensures they survive the entire app lifecycle.

#### 2. Named Routes Only
All navigation uses `Get.toNamed()` and `Get.offAllNamed()` — NEVER `Get.to(() => SomeView())`. This ensures that Bindings defined in `AppPages` are always triggered.

#### 3. Nigerian KYC Compliance
The KYC screen validates:
- **NIN** (National Identity Number): exactly 11 digits
- **BVN** (Bank Verification Number): exactly 11 digits
Both are required for financial platforms operating in Nigeria.

#### 4. Job Completion Flow (State Machine)
```
To Destination → Arrived → In Progress → Complete (with photo upload)
```
Located in `bookings/views/job_status_view.dart`. Uses `setState` with a step counter. Completion triggers a dialog with photo capture and earnings confirmation.

### Key Models
```dart
class JobRequestModel {
  final String id;
  final String customerName;
  final String serviceType;
  final String location;
  final double distance;
  final String price;
  final DateTime dateTime;
  final String status;        // 'Pending', 'Accepted', 'Ongoing', 'Completed'
  final String? customerImage;
}
```

---

## 6. Admin Portal (`handygo_admin/`)

### Purpose
Web-based management dashboard for platform administrators to monitor KPIs, manage users/workers, verify KYC submissions, track jobs, and configure platform settings.

### Architecture
```
lib/app/
├── core/
│   ├── constants/
│   │   └── colors.dart              # AdminColors (dark theme palette)
│   ├── theme/
│   │   └── admin_theme.dart         # Dark theme with Inter font
│   └── widgets/                     # REUSABLE WIDGET LIBRARY
│       ├── admin_shell.dart         # Main layout: sidebar + topbar + content
│       ├── glass_card.dart          # Universal glassmorphic container
│       ├── glass_data_table.dart    # DataTable wrapped in glass card
│       ├── stat_card.dart           # KPI card with hover animation + glow
│       └── status_chip.dart         # Auto-colored status badge
├── modules/
│   ├── dashboard/                   # KPI overview, charts, activity feed
│   ├── users/                       # Customer management table
│   ├── workers/                     # Worker management with KYC filter
│   ├── jobs/                        # Job tracking with status tabs
│   ├── analytics/                   # Charts + KPIs + top worker leaderboard
│   ├── kyc/                         # NIN/BVN verification queue
│   └── settings/                    # Platform config, notifications, fees
├── routes/
│   └── admin_routes.dart
└── main.dart
```

### Admin Shell Layout
```
┌─────────────────────────────────────────────────┐
│ [Logo] HandyGo Admin Portal                     │ ← Top Bar (Glass)
├──────────┬──────────────────────────────────────│
│ Dashboard│                                       │
│ Customers│       Content Area                    │
│ Workers  │       (AnimatedSwitcher)              │
│ Jobs     │                                       │
│ Analytics│       Currently showing:              │
│ KYC ⚠ 8 │       DashboardView                   │
│ Settings │                                       │
│          │                                       │
│ [< >]    │                                       │ ← Collapse toggle
└──────────┴──────────────────────────────────────┘
```

### Reusable Widgets (Production Pattern)

#### GlassCard
```dart
GlassCard(
  glowColor: Colors.blue,  // Optional ambient glow
  blur: 12,                // Blur intensity
  child: YourContent(),
)
```

#### GlassDataTable
```dart
GlassDataTable(
  title: 'All Workers',
  trailing: Text('5 records'),
  columns: [...],
  rows: [...],
)
```

#### StatusChip
```dart
StatusChip(label: 'Verified')   // Auto → green
StatusChip(label: 'Pending')    // Auto → orange
StatusChip(label: 'Rejected')   // Auto → red
```

### Charts (fl_chart)
| Chart | Widget | Data |
|-------|--------|------|
| Revenue Line | `RevenueChart` | Weekly revenue with gradient fill + tooltips |
| Job Category Pie | `JobCategoryChart` | Plumbing 35%, Electrical 25%, Cleaning 20%, AC 20% |
| Weekly Volume Bar | `WeeklyJobsChart` | Completed vs Pending per day |

---

## 7. Shared Assets

Assets are stored in the **worker app** and **customer app** independently (identical copies):
```
assets/images/
├── home_image.jpg          # Hero backgrounds
├── home_image_2.jpg
├── home_image_3.jpg
├── onboarding.jpg          # Auth/KYC backgrounds
├── onboarding_2.jpg
├── profile.jpg             # Default profile photo
├── favourite.jpg/2/3       # Service images
├── facebook.jpg            # Social auth icons
└── google.jpg
```

---

## 8. Known Issues & Technical Debt

| Issue | Status | Notes |
|-------|--------|-------|
| No backend connected | ⚠️ Pending | All data is dummy/hardcoded in controllers |
| `FadeInAnimation.dispose()` had `super.initState()` bug | ✅ Fixed | Was causing assertion errors on login |
| `MainController` not found on navigation | ✅ Fixed | Solved with `InitialBinding` (permanent controllers) |
| Asset filenames with spaces (`IMG_1888 2.JPG`) | ✅ Fixed | Replaced with valid asset paths |
| `JobRequestCard` type mismatch (`Map` vs `JobRequestModel`) | ✅ Fixed | Now uses `JobRequestModel` |
| Admin `google_fonts` requires internet on first load | ⚠️ Known | Consider bundling Inter font for offline |
| Glassmorphism performance on low-end Android | ⚠️ Acceptable | Blur is used sparingly; not in scrollable lists |

---

## 9. Recommended Next Steps

### Priority 1: Backend Integration
- [ ] Set up Firebase/Supabase project
- [ ] Implement `AuthRepository` with phone auth + OTP
- [ ] Connect `BookingsController` to Firestore real-time streams
- [ ] Implement `WalletRepository` with Paystack/Flutterwave integration
- [ ] Build KYC verification API (NIN/BVN validation via VerifyMe or Smile ID)

### Priority 2: Real-Time Features
- [ ] WebSocket or Firebase Cloud Messaging for job alerts
- [ ] Live location tracking during "To Destination" phase
- [ ] Real-time chat with Firestore or Socket.IO

### Priority 3: Production Hardening
- [ ] Add unit tests for all controllers
- [ ] Implement proper error handling and loading states
- [ ] Add offline-first caching with Hive or shared_preferences
- [ ] Implement push notifications (Firebase FCM)
- [ ] App Store / Play Store submission prep

### Priority 4: Admin Enhancements
- [ ] Add authentication for admin portal (email/password)
- [ ] Make data tables sortable and paginated
- [ ] Connect charts to real analytics data
- [ ] Add CSV/PDF export functionality
- [ ] Implement real-time activity feed via WebSocket

---

## 10. How to Run

```bash
# Customer App
cd handygo && flutter run

# Worker App
cd handygo_worker && flutter run

# Admin Portal (Web)
cd handygo_admin && flutter run -d chrome
```

---

## 11. Design Philosophy

1. **Glassmorphism First**: Every card, modal, and navigation element uses frosted glass effects for a premium feel
2. **Asset-First Strategy**: All critical images are local (no network dependency for core UI)
3. **Design Token Discipline**: No magic numbers — all spacing uses `AppSpacing`, all colors use `AppColors`/`AdminColors`
4. **Micro-Animation Language**: `FadeInAnimation` widget with configurable delays creates a fluid, high-end loading experience
5. **Nigerian Market Focus**: KYC with NIN/BVN, Naira (₦) currency, Lagos-based dummy data, local phone formats (+234)
6. **Responsive Architecture**: Admin uses `LayoutBuilder` for desktop/tablet/mobile breakpoints; mobile apps use `SafeArea` + `SingleChildScrollView` for all screen sizes

---

*This document is the single source of truth for the HandyGo project. Any AI assistant or developer reading this should have full context to continue development without ambiguity.*
