# Google Play Store — Swaminarayan Maala

**Package:** `com.swaminarayanmalaa.app`  
**Default language:** English (United States)  
**Category:** Lifestyle  
**Content rating:** Everyone  
**Contact:** (add your Play Console developer email)

---

## App name (30 chars max)

```
Swaminarayan Maala
```

## Short description (80 chars max)

```
Jai Swaminarayan — daily Naam Jap, 108 mala, kids jap & offline sadhana.
```
(79 characters)

## Full description (4000 chars max)

```
Jai Swaminarayan.

Swaminarayan Maala is a calm, offline devotion app for daily Shri Swaminarayan Naam Jap. Count your jap, complete 108-bead malas, remember the Sahajanand Namavali path, bless children with Kids Jap, and track your sadhana — all on your device.

WHY SWAMINARAYAN MAALA
• Built for Akshar-Purushottam / Gunatit Guru Parampara–inspired remembrance
• Beautiful tilak-chandlo brand mark and mandir-inspired design
• Fully offline — no account required, no ads, no social feed
• Works in English, Hindi, and Gujarati

DAILY NAAM JAP
• Large, gentle tap jap with optional sound and haptic feedback
• Focus Mode and Night Jap for quieter sadhana
• Per-mantra bead position (0–107) with mala completion celebration
• Optional soft ambient mandir music (default track included; import your own)

108-BEAD MALA
• Full-screen rudraksha-style mala
• Count, today’s mala, and Jap button inside the loop
• Smooth bead travel and horizontal flip after each completed mala
• Flower petal celebration when a mala is complete

MANTRAS & NAMAVALI
• Swaminarayan mantra library
• Favorites and custom mantras
• Sahajanand Namavali–style bead labels for deeper remembrance

KIDS JAP
• Playful falling-blessings game
• Every successful tap is real jap toward the same daily target and streak
• Safe, simple targets for young devotees

SADHANA ANALYTICS
• Today, week, month, year, and lifetime insights
• Streaks, sessions, and daily heatmaps
• Animated counters for a living progress feel

PROFILE & SETTINGS
• Profile photo and name
• Reminders for morning, afternoon, or evening jap
• Theme, language, music import, and data export/import

IMPORTANT DISCLAIMER
Swaminarayan Maala is an independent devotion app inspired by publicly known teachings of the Akshar-Purushottam tradition. It is not affiliated with, endorsed by, or an official product of BAPS Swaminarayan Sanstha.

Start today. Har saans mein Naam, har pal mein shanti.
Jai Swaminarayan.
```

---

## Hindi short description (optional locale)

```
जय स्वामिनारायण — दैनिक नाम जप, १०८ माला, बच्चों का जप व ऑफ़लाइन साधना।
```

## Gujarati short description (optional locale)

```
જય સ્વામિનારાયણ — દૈનિક નામ જપ, ૧૦૮ માળા, બાળ જપ અને ઑફલાઇન સાધના।
```

---

## Graphics checklist (upload in Play Console)

| Asset | Spec | File |
|-------|------|------|
| App icon (launcher) | generated into Android/iOS | `assets/icons/app_icon.png` |
| Adaptive FG | transparent tilak | `assets/icons/app_icon_foreground.png` |
| Play Store icon | 512 × 512 PNG, 32-bit | `graphics/play_icon_512.png` |
| High-res icon | 1024 × 1024 PNG | `graphics/app_icon_1024.png` |
| Feature graphic | 1024 × 500 PNG | `graphics/feature_graphic_1024x500.png` |
| Phone screenshots | 6 images | `screenshots/android/01_home` … `06_analytics` |

## Suggested screenshot order (captions)

1. Home — today’s jap & streak  
2. Jap screen — tap to jap  
3. Mala — 108 rudraksha loop  
4. Kids Jap — blessings game  
5. Analytics — sadhana insights  
6. Music settings — ambient & import  

## Data safety (Play Console form — typical answers)

- App collects: **none** by default (all data stays on device in Hive)
- Shared with third parties: **No**
- Encrypted in transit: N/A (no cloud sync)
- Users can request deletion: local reset in Settings → Data
- Kids: app is suitable for families; Kids Jap is optional play mode

## Privacy policy

Host a short privacy policy URL (required). Suggested points:
- Offline-first; jap counts & settings stored only on device
- Optional: notifications (reminders), photo picker (profile only)
- No ads, no analytics SDKs required for core use
- Contact email for questions

## Release notes (1.0.0)

```
First release of Swaminarayan Maala.
• Daily Naam Jap & 108 mala
• Kids Jap, stories, analytics
• English / Hindi / Gujarati
• Offline — Jai Swaminarayan
```

## Before you upload

1. Create app in Play Console → package `com.swaminarayanmalaa.app`
2. Upload AAB: `flutter build appbundle --release`
3. Fill store listing from this file
4. Upload icon, feature graphic, screenshots
5. Complete Data safety + Content rating questionnaire
6. Add privacy policy URL
7. Internal testing track first, then Production
