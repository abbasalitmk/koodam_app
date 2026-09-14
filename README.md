# Koodam Mobile App (കൂടം) — Flutter iOS & Android Client

> **Tagline:** Meet • Explore • Belong (Discover Events. Meet People. Find Your Connection.)  
> **Platform Target:** Flutter (Dart 3.x) Cross-Platform iOS & Android Native App  
> **Production Backend API:** [https://koodam-mu.vercel.app](https://koodam-mu.vercel.app)  
> **Swagger API Reference:** [https://koodam-mu.vercel.app/api/docs](https://koodam-mu.vercel.app/api/docs)  
> **Backend Repository:** [git@github.com:abbasalitmk/koodam.git](https://github.com/abbasalitmk/koodam)  
> **App Repository:** [git@github.com:abbasalitmk/koodam_app.git](https://github.com/abbasalitmk/koodam_app)

---

## 1. Overview & Core Features

Koodam is Kerala's first hyperlocal social discovery and intentional dating platform tailored for all 14 Kerala districts and global Malayali diaspora communities (Dubai, Doha, London, Bengaluru, Singapore).

### Key Features Implemented:
1. **Hyperlocal Kerala Districts Feed:**
   - Real-time district switcher across all 14 administrative districts (Thiruvananthapuram, Kochi, Kozhikode, Wayanad, etc.) and global diaspora hubs.
   - Category filtering (Heritage Walks, Turf Football, Tech Chai, Indie Arts).
2. **Strict Single-Day Policy:**
   - Event creation locked to single calendar day with maximum duration of 8 hours.
   - 50:50 gender equilibrium reservation system.
   - Entry QR Pass generator (`#KD-XXXX`).
3. **3-Peer Trust Engine:**
   - Hosts share tokenized WhatsApp vouch links with trusted peers before publishing.
4. **Intentional Dating Deck:**
   - Intentional candidate discovery cards with native district, current district, intentions, and Malayalam cultural tags.
   - "Send Love" action with 140-character note and 48-hour automated expiration.
5. **Interactive Live Radar Map:**
   - PostGIS viewport discovery pins with Ghost Centroid privacy obfuscation (~400m–900m gaussian blur).
6. **Dual-Track Companion Messaging:**
   - Separate tabs for "Love Connections" vs "Community Gatherings".
   - Cultural icebreakers ("Sulaimani or Filter Coffee?", "Monsoon spots in Wayanad").

---

## 2. Directory Structure

```
koodam_app/
├── API_DOCUMENTATION.md         # Full backend REST & WebSocket API specification
├── stitch_kerala_dating/        # 25 High-fidelity UI mockups & rendered screenshots
├── lib/
│   ├── core/
│   │   ├── constants/           # Kerala districts catalog & coordinates
│   │   ├── network/             # ApiService connected to live Vercel backend
│   │   └── theme/               # Dark theme, Kerala Emerald Teal & Kasavu Gold palette
│   ├── models/                  # Event, DatingCandidate, Connection, Message models
│   ├── screens/
│   │   ├── splash_screen.dart   # Malayalam branding splash screen
│   │   ├── auth_otp_screen.dart # Phone & WhatsApp OTP onboarding
│   │   ├── home_feed_screen.dart# District gathering feed & join RSVP
│   │   ├── radar_map_screen.dart# Live radar with Ghost Centroid privacy blur
│   │   ├── create_event_screen.dart # Single-day event host wizard (max 8h)
│   │   ├── dating_deck_screen.dart  # Intentional dating candidate deck & 140-char note
│   │   ├── chat_screen.dart     # Dual-track companion messaging & icebreakers
│   │   ├── profile_screen.dart  # Photos, blue tick verification & privacy toggles
│   │   └── main_shell.dart      # 5-tab BottomNavigationBar container
│   └── main.dart                # Application entrypoint
└── pubspec.yaml                 # Flutter project configuration
```

---

## 3. Getting Started

### Prerequisites:
- Flutter SDK (3.24+ / 3.47+)
- Dart 3.x
- iOS Simulator / Android Emulator

### Run the App:
```bash
# 1. Install dependencies
flutter pub get

# 2. Launch on connected device or simulator
flutter run
```
