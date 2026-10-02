# SwamiNaam — Deep-Mode Master Build Prompt

> **How to use:** Paste this entire document into a new Cursor / Claude / GPT coding chat as the sole system brief. Instruct the agent: *“Rebuild this Flutter app as SwamiNaam per this deep prompt. Mirror JapNaam architecture 1:1; replace all multi-deity content with Swaminarayan / Akshar-Purushottam content. Do not claim official BAPS affiliation.”*
>
> **Reference product:** JapNaam (`com.japnaam.application`) — offline Flutter Naam-Jap app.  
> **Target product:** SwamiNaam (`com.swaminaam.application`) — Shri Swaminarayan–only twin.  
> **Research north star (tone & topics only):** https://www.baps.org/

---

## 1. Role & mission

You are a senior Flutter engineer + product designer + spiritual-content editor.

**Mission:** Build a production-grade, offline-first Flutter devotion app named **SwamiNaam** that preserves **every functional behavior of JapNaam** while replacing the multi-deity pantheon with a **Shri Swaminarayan / Akshar-Purushottam / Gunatit Guru Parampara** focus inspired by publicly known BAPS tradition.

**Non-goals for this rebuild:**
- No official BAPS partnership, branding, or endorsement claims
- No accounts, cloud sync, ads, or social feeds
- No multi-deity pantheon (Ram, Krishna, Shiva, Hanuman, Durga, Ganesh, etc. as selectable deities)
- No verbatim copyrighted BAPS arti / kirtan / Namavali path lyrics from publications

**Tone:** Calm, respectful, educational, satsang-friendly. Greeting everywhere: **Jai Swaminarayan**.

---

## 2. Product identity & positioning

| Field | Value |
|-------|--------|
| App name | `SwamiNaam` |
| Tagline | `Jai Swaminarayan — Har Saans Mein Naam, Har Pal Mein Shanti.` |
| Package | `com.swaminaam.application` |
| Category | Lifestyle / Health & Fitness / Books & Reference |
| Positioning | Independent digital mandir for daily Swaminarayan Naam Jap, 108-bead mala, Sahajanand Namavali-style remembrance path, kids jap, stories, and sadhana tracking — offline on device |
| Legal stance | Independent devotion app **inspired by** publicly known BAPS Akshar-Purushottam tradition. **Not** an official BAPS product. No BAPS logo, no Akshardham trademark assets, no copyrighted liturgy pasted verbatim. |
| Visual motif | **Tilak-chandlo** (Urdhva Pundra / U-shaped chandan tilak + red kumkum chandlo) as primary brand mark; ॐ allowed respectfully as a sacred symbol, not as the sole identity |

**Onboarding promise (one line):**  
Daily Swaminarayan Naam Jap with mala, Namavali path, guru parampara presence, kids blessings game, and offline sadhana insights.

---

## 3. Non-negotiable feature parity checklist (from JapNaam)

Implement **all** of the following. Content changes only where this prompt specifies Swaminarayan replacements.

### Shell & navigation
- [ ] Splash → Onboarding (first launch) → Main shell
- [ ] 5 bottom tabs: **Home · Jap · Mala · Kids · Profile**
- [ ] Fade/slide route transitions matching JapNaam feel
- [ ] IndexedStack shell so tab state persists

### Jap
- [ ] Large tap counter (increment +1 per tap)
- [ ] Selected mantra display (name + script text)
- [ ] Focus mode (minimal chrome)
- [ ] Night mode (dark jap surface)
- [ ] Session start/end; active session tracking
- [ ] Per-mantra bead position (0–107) and mala++
- [ ] Daily target progress for selected mantra
- [ ] Optional tap sound + haptic
- [ ] Optional background mandir-style ambient music (generic licensed / original only)
- [ ] Optional volume-button jap (if platform allows; same as JapNaam)

### Mala
- [ ] Visual 108-bead mala
- [ ] Sync with per-mantra bead position
- [ ] Wrap celebration when mala completes (bead resets, mala count++)

### Mantras
- [ ] Seed library (Swaminarayan-only — see §6)
- [ ] List, detail, favorites
- [ ] **Add custom mantra** (user text; focus murti/guru picker only)
- [ ] Edit/delete custom mantras; seed mantras protected or non-deletable

### Kids
- [ ] Entry hub → target select → falling-blessings game
- [ ] Every successful tap = **real jap** via `JapMode.kids`
- [ ] Session count toward same daily progress / lifetime / streak as adult jap
- [ ] Swaminarayan kid-safe visuals only (see §8)

### Stories & quotes
- [ ] Offline stories list + detail + favorites (~15 Swaminarayan stories)
- [ ] Daily rotating quotes (home) from Swaminarayan / Pramukh Swami Maharaj / Mahant Swami Maharaj teachings — **paraphrased**; cite inspiration from baps.org in code comments / about screen, not as official attribution of published quotes unless public domain

### Progress / Sadhana
- [ ] Current + longest streak
- [ ] Today / week / month / year views
- [ ] Heatmap-style activity
- [ ] Insights: lifetime jap, mala, sessions, duration
- [ ] Streak milestones: 3, 7, 21, 40, 108, 365

### Profile & settings
- [ ] Profile name + optional photo (system picker; no broad gallery permission abuse)
- [ ] Settings hub with subpages:
  - Jap settings (target presets, focus, night, haptic, sound, volume-button, auto-start last mantra)
  - Music (enable + volume)
  - **Guru / Murti focus** (replaces deity settings)
  - Reminder (enable, time, morning/afternoon/evening flags; reminder mode: normal | kids | ask)
  - Appearance (system / light / dark)
  - Language (en / hi / gu)
  - Data (export JSON, import JSON, reset today, reset all)
- [ ] Favorites screen (mantras + stories)

### i18n & stack
- [ ] English / Hindi / Gujarati via Flutter gen-l10n
- [ ] Flutter + Provider + Hive CE, offline-first, **no account**
- [ ] Local notifications for reminders
- [ ] Share/export backup via share_plus / file_picker

---

## 4. Information architecture & routes (1:1 map)

Rename package/imports from `jap_naam` → `swaminaam` (or project folder name), keep route *structure* identical:

| Route constant | Path | Screen |
|----------------|------|--------|
| splash | `/` | SplashScreen |
| onboarding | `/onboarding` | OnboardingScreen |
| home | `/home` | MainShell (tabs) |
| jap | `/jap` | JapScreen (`mantraId?`) |
| mantras | `/mantras` | MantraListScreen |
| mantrasAdd | `/mantras/add` | AddMantraScreen |
| mantrasDetail | `/mantras/detail` | MantraDetailScreen |
| mala | `/mala` | MalaScreen |
| progress | `/progress` | ProgressScreen |
| stories | `/stories` | StoriesScreen |
| storiesDetail | `/stories/detail` | StoryDetailScreen |
| favorites | `/favorites` | FavoritesScreen |
| kidsJap | `/kids-jap` | KidsJapEntryScreen |
| settings | `/settings` | SettingsScreen |
| settingsJap | `/settings/jap` | JapSettingsScreen |
| settingsMusic | `/settings/music` | MusicSettingsScreen |
| settingsDeity → **settingsFocus** | `/settings/focus` | **GuruFocusSettingsScreen** (was DeitySettings) |
| settingsReminder | `/settings/reminder` | ReminderSettingsScreen |
| settingsAppearance | `/settings/appearance` | AppearanceSettingsScreen |
| settingsLanguage | `/settings/language` | LanguageSettingsScreen |
| settingsData | `/settings/data` | DataSettingsScreen |
| profile | `/profile` | ProfileScreen |
| deitySelect → **focusSelect** | `/focus` | same as GuruFocusSettings |

**Tabs (IndexedStack):** HomeScreen · JapScreen · MalaScreen · KidsJapTabScreen · ProfileScreen

**Suggested `lib/` layout (mirror JapNaam):**
```
lib/
  main.dart
  app/ (app.dart, routes.dart, theme/)
  core/ (constants, helpers, providers, services, widgets)
  data/ (local/local_database.dart, models/)
  features/ (splash, onboarding, shell, home, jap, mala, mantras,
             kids, stories, progress, profile, settings, favorites)
  l10n/
assets/
  images/ backgrounds/ icons/ audio/ stories/ data/ kids/ gurus/
```

---

## 5. Domain model (Hive boxes, sessions, streaks)

### Boxes (same names OK)
- `settings` · `mantras` · `daily_progress` · `sessions` · `favorites` · `meta`

### Constants
- `malaBeads = 108`
- `defaultDailyTarget = 108`
- `presetTargets = [108, 216, 500, 1008, 5000, 10000]`
- `kidsTargets = [11, 21, 51, 108, 216]`
- `databaseVersion = 1` (fresh app; no JapNaam legacy migration required unless you import logic for future)

### Settings keys (rename deity → focus)
Keep JapNaam keys where possible; change:
- `selected_deity_id` → `selected_focus_id` (or keep key name internally but map to guru/murti IDs only)
- Default focus: `swaminarayan`
- Default mantra: `mantra_swaminarayan`

### Models (fields same as JapNaam)
- **MantraModel:** id, name, text, transliteration, `deityId` → rename field to `focusId` (guru/murti), target, totalCount, isFavorite, createdAt, isCustom
- **DailyProgressModel:** dateKey + mantraId composite key `YYYY-MM-DD|mantraId`; aggregate by day for streaks
- **JapSessionModel:** mode `normal` | `kids`
- **FavoriteModel:** type `mantra` | `story`
- **StoryModel:** EN + HI (+ GU preferred); extend to include `titleGu`, `descriptionGu`, `contentGu` if practical
- **SettingsModel:** focus id, mantra id, theme, sound, music, haptic, volume button, daily target, language, userName, profileImagePath, nightMode, focusMode, autoStart, reminderMode, reminder block

### Increment rules (must match JapNaam)
1. `incrementJap(mantraId, amount)` updates today progress for that mantra
2. Advances per-mantra bead; every 108 → mala++
3. Updates mantra lifetime + app lifetime counts
4. Updates streak if first jap of calendar day (gap logic: consecutive days)
5. Bumps active session count if one is open
6. Kids taps call the same increment path with `JapMode.kids` session

### Backup JSON shape
```json
{
  "version": 1,
  "exportedAt": "ISO-8601",
  "settings": {},
  "mantras": {},
  "dailyProgress": {},
  "sessions": {},
  "favorites": {},
  "meta": {}
}
```

---

## 6. Swaminarayan content bible

### 6.1 Guru / Murti focus list (replaces deities)

Selectable “focus presence” — **not** generic Hindu deities. Store as `FocusInfo` (rename `DeityInfo`).

| Order | id | EN name | Greeting (all locales conceptually) | Symbol motif |
|------:|----|---------|--------------------------------------|--------------|
| 1 | `swaminarayan` | Bhagwan Shri Swaminarayan (Sahajanand Swami / Nilkanth Varni) | Jai Swaminarayan | Tilak-chandlo |
| 2 | `gunatitanand` | Aksharbrahma Gunatitanand Swami | Jai Swaminarayan | Lotus / Akshar |
| 3 | `bhagatji` | Bhagatji Maharaj | Jai Swaminarayan | Tilak-chandlo |
| 4 | `shastriji` | Shastriji Maharaj | Jai Swaminarayan | Mandir shikhar |
| 5 | `yogiji` | Yogiji Maharaj | Jai Swaminarayan | Soft smile / lotus |
| 6 | `pramukh_swami` | Brahmaswarup Pramukh Swami Maharaj | Jai Swaminarayan | Tilak-chandlo |
| 7 | `mahant_swami` | Pragat Brahmaswarup Mahant Swami Maharaj | Jai Swaminarayan | Tilak-chandlo |

Provide EN / HI / GU display names for each.  
Assets: respectful illustrated or photographic-style murti/guru images under `assets/gurus/` — **no caricatures**, no BAPS logo watermarks, no official trademarked brand marks.

**About / legal microcopy (must ship):**  
“SwamiNaam is an independent devotion app inspired by publicly known teachings of the Akshar-Purushottam tradition. It is not affiliated with, endorsed by, or an official product of BAPS Swaminarayan Sanstha. Research inspiration: baps.org.”

### 6.2 Tilak-chandlo meaning (UI copy seed)

Short educational blurb for onboarding / kids / a story:

- Men traditionally apply a U-shaped chandan tilak (ūrdhva puṇḍra) with a red kumkum chandlo while remembering Bhagwan and the guru and chanting the Swaminarayan mantra (paraphrase of public satsang practice; do not paste long copyrighted shastra verses).
- Women traditionally apply the kumkum chandlo.
- In-app: use tilak-chandlo as splash logo, app icon motif, and kids sticker — not as medical/ritual instruction beyond gentle educational tone.

### 6.3 Seed mantra library (Swaminarayan-only)

Seed at least these (id · name · text · transliteration · focusId · default target 108):

| id | name | text | transliteration | focusId |
|----|------|------|-----------------|---------|
| `mantra_swaminarayan` | Swaminarayan | श्री स्वामिनारायण | Shri Swaminarayan | swaminarayan |
| `mantra_jai_swaminarayan` | Jai Swaminarayan | जय स्वामिनारायण | Jai Swaminarayan | swaminarayan |
| `mantra_om_swaminarayanaya` | Om Shri Swaminarayanaya Namah | ॐ श्री स्वामिनारायणाय नमः | Om Shri Swaminarayanaya Namah | swaminarayan |
| `mantra_sahajanand` | Sahajanand | श्री सहजानंद | Shri Sahajanand | swaminarayan |
| `mantra_nilkanth` | Nilkanth Varni | नीलकंठ वर्णी | Nilkanth Varni | swaminarayan |
| `mantra_gunatit` | Gunatit Smruti | गुणातीत | Gunatit | gunatitanand |
| `mantra_akshar_purushottam` | Akshar-Purushottam | अक्षर-पुरुषोत्तम | Akshar-Purushottam | shastriji |
| `mantra_pramukh_joy` | In the Joy of Others | पर की खुशी में | Par Ki Khushi Mein | pramukh_swami |
| `mantra_mahant_shanti` | Shanti Smruti | शांति | Shanti | mahant_swami |

**Custom mantras:** allowed; `focusId` picker shows only the 7 focuses above. Categories for filters: `swaminarayan`, `gunatit`, `namavali`, `sadhana`, `custom`.

### 6.4 Shri Sahajanand Namavali mode (special mala path)

**Product intent:** A special jap / mala path celebrating the *idea* of 108 divine names of Bhagwan Shri Swaminarayan, inspired by the public BAPS practice instituted around Pramukh Swami Maharaj’s 98th birthday (15 Dec 2018) by the wish of Mahant Swami Maharaj (per baps.org news). Mahant Swami Maharaj’s encouragement of daily Namavali remembrance is cultural context — **do not claim official liturgy rights**.

**Implementation rules:**
1. Add a seed mantra or dedicated mode: `mantra_namavali_path` named **“Sahajanand Namavali Path”**.
2. UI: each of 108 beads advances a short **original educational remembrance label** (EN/HI/GU), e.g. “Sahajanand — naturally blissful”, “Nilkanth — the young pilgrim”, “Swaminarayan — the divine Name”, “Akshar-Purushottam — eternal principle”, “Compassion for all”, “Ghar mandir devotion”, etc.
3. **Do NOT** paste the official *Athah Sahajanand Namavali Pathah* Sanskrit/Gujarati verses from BAPS / MyBAPS / Anirdesh publications into the app or this codebase.
4. Optional: link in About: “Learn more about the official Namavali tradition on baps.org” (external URL only).
5. Completing 108 beads = 1 Namavali mala (same mala++ mechanics).

### 6.5 Stories outline (~15 — original wording)

Replace JapNaam’s 15 multi-deity stories. Write **original** EN + HI (+ GU) prose (~300–500 words EN). Categories: `swaminarayan`, `gunatit`, `seva`, `sadhana`, `kids`.

| Suggested id | Title (EN) | Focus |
|--------------|------------|-------|
| `story_nilkanth_yatra` | Nilkanth Varni’s Pilgrimage | Young renunciate’s journey of austerity and compassion |
| `story_sahajanand_compassion` | Sahajanand’s Compassion | Reforms, care for the poor and fallen |
| `story_gunatit_akshar` | Gunatitanand Swami — Akshar | Ideal of becoming aksharrup |
| `story_bhagatji_devotion` | Bhagatji Maharaj’s Devotion | Humility and unwavering faith |
| `story_shastriji_upasana` | Shastriji Maharaj — Akshar-Purushottam | Establishing upasana in mandirs |
| `story_yogiji_everyone_divine` | Yogiji Maharaj — Everyone Is Divine | Love, affection, youth inspiration |
| `story_pramukh_joy` | Pramukh Swami Maharaj — Joy of Others | “In the joy of others lies our own” (paraphrase spirit) |
| `story_mahant_living_satsang` | Mahant Swami Maharaj — Living Satsang | Present guru, sadhana, harmony |
| `story_tilak_chandlo` | Meaning of Tilak-Chandlo | Identity of devotion and remembrance |
| `story_namavali_inspiration` | Why 108 Names Matter | Namavali as daily remembrance (no lyric dump) |
| `story_ghar_mandir` | Ghar Mandir | Home shrine as living devotion |
| `story_mandir_seva` | Mandir Seva | Seva as worship |
| `story_youth_satsang` | Youth Satsang | Discipline, friendship, values |
| `story_akshardham_devotion` | Akshardham as Living Devotion | Informational spiritual meaning — not tourism spam |
| `story_jai_swaminarayan` | The Greeting That Unites | Jai Swaminarayan as peace and belonging |

Thumbnails: original illustrations under `assets/stories/` — serene, temple cream/saffron palette.

### 6.6 Daily quotes (rotate on Home)

~20–30 short paraphrased lines. Attribute loosely as “Inspired by Swaminarayan satsang teachings” or “In the spirit of Pramukh Swami Maharaj / Mahant Swami Maharaj” — **do not invent fake exact quotations with false citation**. Prefer original lines in the voice of the tradition:

Examples (seed; expand):
- “In the joy of others, find your own peace.” (spirit of Pramukh Swami Maharaj)
- “Jai Swaminarayan — let every breath remember the Name.”
- “Become divine; see divinity in all.” (spirit of Yogiji Maharaj)
- “Small daily jap builds a lifetime of shanti.”
- “Seva is the silent mala of the hands.”
- “Where there is harmony, there is satsang.”

Store in `assets/data/quotes.json` with `en`, `hi`, `gu`.

---

## 7. Screen-by-screen UX specs

### Splash
- Duration ~2.8s
- Center: **tilak-chandlo mark** + app name **SwamiNaam**
- Subtitle: tagline
- Soft gold glow pulse + light particle drift (diya/dust)
- Then → onboarding or home

### Onboarding (4 pages)
1. **Welcome** — Jai Swaminarayan; digital mandir for Naam Jap  
2. **Jap & Mala** — 108 beads, daily target  
3. **Sadhana** — streaks, progress chips  
4. **Choose focus** — horizontal list of 7 guru/murti focuses; sets default mantra for that focus  
CTA: Begin / Jai Swaminarayan

### Home
- Greeting: Jai Swaminarayan + user name if set
- Today’s jap progress ring/bar for selected mantra
- Streak card
- Daily quote card
- Quick actions: Start Jap, Mala, Mantras, Stories, Kids
- Selected focus avatar (guru/murti)

### Jap
- Full-screen tap target
- Counter, bead indicator, mala count, target progress
- Mantra switcher sheet
- Toggles: focus mode, night mode, sound, haptic (per settings)
- Session ends on leave / explicit stop

### Mala
- Circular / string 108 beads; current bead highlighted gold
- Tap advances same as jap increment OR mirrors jap bead (match JapNaam behavior: typically shared increment)
- Completion animation (soft chime optional + haptic)

### Mantras
- Grid/list with focus filter chips
- Detail: meaning line, start jap, favorite, edit if custom
- FAB: Add mantra
- Highlight **Namavali Path** as featured card

### Kids hub + game
- See §8

### Stories
- List with thumbnail, title, short description
- Detail: hero image + scrollable body
- Favorite toggle

### Progress
- Streak header + milestones
- Segmented: Day / Week / Month / Year
- Heatmap / bars
- Lifetime stats

### Profile
- Avatar, name edit
- Links: Progress, Favorites, Settings, About (legal blurb)
- Lifetime summary

### Settings subpages
Mirror JapNaam copy, replacing “Deity” strings with “Guru / Murti focus”. Reminder notification text: “Time for Swaminarayan Naam Jap — Jai Swaminarayan”.

---

## 8. Kids game rules

### Flow
1. Kids tab → entry parchment / welcome  
2. Pick mantra (Swaminarayan seeds only) + target from `kidsTargets`  
3. Start session (`JapMode.kids`)  
4. Game screen: objects fall from top; tap to “catch” → +1 jap  
5. Cheer every N taps; pause; complete dialog when target reached  
6. End session → counts already persisted via incrementJap

### Visual theme (single Swaminarayan kids theme; optional slight variants by focus)
**Falling objects (labels/stickers — not guru caricatures):**
- Lotus, tilak-chandlo sticker, mandir diya, peacock (Gujarat), “जय”, “Jai”, soft star, “ૐ” (respectful)
- Bubbles/text: “Jai Swaminarayan”
- Decor: mandir silhouette, clouds, lotus pond colors

**Colors:** saffron sky wash, cream ground, maroon accents, gold highlights  
**Forbidden:** cartoon mockery of gurus; Ram/Krishna/Shiva falling themes; violent or scary imagery

### Accessibility
- Large tap targets; readable Devanagari/Gujarati; reduce motion option if easy (pause + fewer objects)

---

## 9. Localization strategy (EN / HI / GU)

- Use Flutter `gen-l10n` (`l10n.yaml`, ARB or same pattern as JapNaam).
- All chrome strings localized; mantra *script* text stays in original script field.
- Stories: store EN+HI+GU in JSON; UI picks by `languageCode`.
- Quotes: EN+HI+GU.
- Focus names + greetings: all three languages.
- Key string remaps from JapNaam:
  - `selectDeity` → `Select Guru / Murti`
  - `appName` → `SwamiNaam`
  - `appSlogan` → `Jai Swaminarayan — Har Saans Mein Naam, Har Pal Mein Shanti.`
  - Onboarding titles rewritten for Swaminarayan Naam Jap + Namavali + parampara

---

## 10. Design system tokens

Keep JapNaam’s temple warmth; lean slightly more maroon + cream for Swaminarayan mandir feel.

```dart
// Brand
primary:        #C96A24  // saffron
primaryDeep:    #5A2417
maroon:         #8B2E1F
templeRed:      #A63D2F
gold:           #D8A84E
goldSoft:       #E8C87A
chandloRed:     #C62828  // tilak-chandlo accent (new)
tilakCream:     #F5E6C8  // chandan-like (new)

// Light
background:     #FFF8ED
surface:        #FFFDF8
textPrimary:    #3A241B
textSecondary:  #6B4E42

// Dark / night jap
darkBackground: #17110E
darkSurface:    #221A16
```

**Typography:** Clear readable Devanagari/Gujarati-capable fonts (e.g. Noto Sans Devanagari / Noto Sans Gujarati + a warm display for English brand). Avoid Inter/Roboto as hero brand fonts if you add custom fonts; Material defaults OK for body if assets constrained.

**Iconography:** Tilak-chandlo app icon on maroon/saffron adaptive background `#8B2819` or `#5A2417`.

**Motion:** Splash glow, bead highlight, mala complete shimmer, kids pop — intentional, not noisy.

---

## 11. Tech stack & architecture (Flutter mirror)

```yaml
# pubspec essentials (align versions with modern stable Flutter)
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  provider: ^6.1.5
  hive_ce: ^2.11.3
  hive_ce_flutter: ^2.3.1
  path_provider: ^2.1.5
  intl: any
  uuid: ^4.5.1
  audioplayers: ^6.4.0
  flutter_local_notifications: ^19.0.0
  timezone: ^0.10.0
  flutter_timezone: ^4.1.0
  share_plus: ^10.1.4
  file_picker: ^10.1.2
  collection: ^1.19.0
  image_picker: ^1.2.2
```

**Architecture rules:**
- `LocalDatabase` singleton = single source of truth (Hive)
- `AppState` (ChangeNotifier) loads settings, mantras, progress; exposes increment/session APIs
- Services: `AudioService`, `ReminderService`, light analytics no-op or local only
- No Firebase required
- Android package `com.swaminaam.application`; iOS bundle id aligned
- Permissions: notifications, photos (profile/backup only), vibration — declare honestly for Play Data safety

**Assets folders:** `assets/images/`, `assets/gurus/`, `assets/backgrounds/`, `assets/icons/`, `assets/audio/` (generic soft mandir ambient — **no proprietary BAPS kirtan**), `assets/stories/`, `assets/data/` (`stories.json`, `quotes.json`, optional `namavali_labels.json`), `assets/kids/`

---

## 12. Acceptance tests / rebuild checklist

### Functional
- [ ] Fresh install → splash → onboarding → home
- [ ] Selecting each of 7 focuses updates greeting art and default mantra
- [ ] Jap tap increments today count, bead, lifetime; completes mala at 108
- [ ] Switching mantras preserves separate bead positions
- [ ] Focus mode / night mode toggle on Jap
- [ ] Mala screen reflects bead position
- [ ] Add custom mantra with focus picker; jap works
- [ ] Namavali path advances 108 distinct labels without crashing
- [ ] Kids game taps increase same daily progress + kids session mode
- [ ] Stories open offline; favorites persist
- [ ] Quotes rotate (day-based index)
- [ ] Streak increments once per day; breaks after missed day
- [ ] Reminder schedules without crash; copy says Jai Swaminarayan
- [ ] Language switches EN/HI/GU for chrome
- [ ] Export / import backup round-trip
- [ ] Reset today / reset all reseed mantras
- [ ] No Ram/Krishna/Shiva/Hanuman deity list anywhere in UI

### Legal / content
- [ ] About screen has non-affiliation disclaimer
- [ ] No BAPS logo or trademarked Akshardham brand assets
- [ ] No verbatim official arti / Namavali path lyrics
- [ ] Store listing states independent app

### Release
- [ ] `flutter analyze` clean of errors
- [ ] Release AAB builds: `com.swaminaam.application`
- [ ] Launcher icon tilak-chandlo
- [ ] Privacy policy URL ready (clone JapNaam site pattern, rebrand)

---

## 13. Store listing draft stubs

**App name (≤30):** SwamiNaam  

**Short description (≤80):**  
Jai Swaminarayan — peaceful daily Naam Jap, mala & Namavali path.

**Full description (draft):**  
SwamiNaam is a calm digital mandir for daily Shri Swaminarayan Naam Jap.

Do jap with focus, complete 108-bead malas, walk a Sahajanand Namavali remembrance path, keep streaks, read Swaminarayan devotion stories, and let kids learn the Name through a gentle blessings game — all offline on your device.

Features:
• Jap counter with 108-bead mala  
• Sahajanand Namavali-style 108 remembrance path  
• Guru parampara focus (Swaminarayan to Mahant Swami Maharaj)  
• Daily target, streaks & sadhana analytics  
• Mantra library + add your own  
• Kids Jap — falling blessings, real jap count  
• Stories of satsang & seva  
• Soft mandir ambient, tap sound & haptic  
• Reminders · English / Hindi / Gujarati  
• Light, Dark & Night modes  
• Export & import backup — your data stays on your phone  

Independent devotion app inspired by the Akshar-Purushottam tradition. Not an official BAPS product.

Jai Swaminarayan — Har Saans Mein Naam, Har Pal Mein Shanti.

**Release notes v1.0.0:**  
Welcome to SwamiNaam — Jai Swaminarayan. Jap, mala, Namavali path, kids jap, stories, streaks. Offline. EN/HI/GU.

**Data safety:** On-device Hive only; no account; no jap data uploaded.

---

## 14. Out of scope / do not copy

### Do not include
- Multi-deity pantheon (Ram, Radha-Krishna, Mahadev, Hanuman, Ganesh, Durga, Lakshmi, Sita-Ram, Vishnu as selectable deities)
- JapNaam seed mantras/stories/quotes as-is
- Official BAPS logo, wordmarks, or Akshardham trademark marketing assets
- Verbatim copyrighted arti, kirtan, or Sahajanand Namavali pathah lyrics from BAPS publications
- Claims of official endorsement, partnership, or “official BAPS app”
- User accounts, chat, social feed, donations paywall, ads
- Non-Swaminarayan kids themes (Krishna flute catch, etc.)

### Do copy (behavior only)
- JapNaam information architecture, Hive schema patterns, Provider state flow, settings taxonomy, kids game *mechanics*, progress/streak math, backup format, tab shell, focus/night jap UX

### Content research
- Use https://www.baps.org/ for **tone, historical topics, and publicly described practices** only
- Rewrite all story prose originally
- When in doubt on liturgy copyright: **paraphrase or omit**

---

## Build order (recommended for the coding agent)

1. Scaffold Flutter app `swaminaam` / reuse this repo; set package id  
2. Port theme + shell + routes + Hive `LocalDatabase` + `AppState`  
3. Replace focus constants + seed mantras + defaults  
4. Splash / onboarding / home / jap / mala  
5. Mantras CRUD + Namavali labels asset  
6. Progress + favorites + settings suite  
7. Stories JSON + quotes JSON  
8. Kids theme + game  
9. l10n EN/HI/GU  
10. About/legal + store listing assets  
11. Analyze, device QA against §12 checklist  

**Definition of done:** A user who knows JapNaam feels the same calm product — but every word, murti, story, and kids blessing says **Jai Swaminarayan**.

---

*End of deep-mode master prompt.*
