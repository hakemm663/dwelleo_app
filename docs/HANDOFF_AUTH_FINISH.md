# Dwelleo App — Auth (Login + Sign Up) Finish Handoff

**Goal:** make the Flutter app's Login + Sign-up (both steps + OTP) pixel-match
dwelleo.sa, fix the location picker crash, and make the map render. Everything
below is **captured from the live site / verified against the live API** — no
guessing. Values are exact.

The app already works against the real backend (Android sign-up returns an OTP →
account is created in the DB). Remaining work is (1) one layout crash, (2) Maps
config, (3) raising auth UI fidelity to the captured spec.

---

## UPDATE — findings applied by the scraping (Cowork) agent

These are done in the repo already; keep/build on them:

1. **Brand font = `RocGrotesk`** (this was the "fonts don't match"). Downloaded
   from `dwelleo.sa/fonts/roc-grotesk-{regular,bold}.woff2`, converted to `.ttf`
   (Flutter can't use woff2), bundled at `assets/fonts/`, declared in
   `pubspec.yaml` (family `RocGrotesk`, 400 + 700), and set as
   `ThemeData.fontFamily = 'RocGrotesk'`. ONLY 400 & 700 exist — any `w800` in
   the text theme renders as 700 (fine). Run `flutter pub get` so the asset loads.

2. **"Glass" is NOT a blur.** The site card/inputs have `backdrop-filter: none`.
   The frosted look = a **translucent card (`white @10%`) / input (`white @5%`)
   over a dark GRADIENT + accent glow**. Our old flat `#1B1B1B` page made the
   translucent card read as flat grey. Fixed in `core/widgets/auth_background.dart`:
   it now paints a vertical dark gradient (`#1B1B1B → #0E0E0E`) + a lime glow
   rising from the bottom (alpha ~0.16) + a soft top glow. Do NOT add a real
   BackdropFilter — match the site (translucent over gradient).

3. **Exact captured tokens (login, dark):** heading **36 / 700** RocGrotesk;
   subtitle + field labels **14 / 400 @60%** (muted); input **fs 15 / 400**,
   height ~53, radius 14, `white @5%` fill, `white @10%` border, 48px icon inset;
   Sign In label **weight 500**; **disabled Sign In = solid `#A1A1AA`** bg with
   `#3F3F46` label (applied in `app_theme.dart`).

4. **Google Cloud — you are on the WRONG flow.** The "Navigation Connect API"
   config (App details / Data collection & privacy / privacy-policy URL) is for
   sharing driver trip data with Google Maps/Waze — it is **NOT** required to
   render a map in the app, and it's not even available for Maps on iOS. Ignore
   it. To make the in-app map render you only need, on project `dwelleo-60f38`:
   (a) **Maps SDK for iOS** + **Maps SDK for Android** ENABLED,
   (b) the API key's **iOS app restriction** to include `sa.dwelleo.app`,
       `sa.dwelleo.app.dev`, `sa.dwelleo.app.staging` (Android key → applicationId + SHA-1),
   (c) **Billing enabled** on the project (black tiles w/ no error = billing off),
   then `flutter clean && pod install && flutter run`.

### Forgot Password feature — VERIFIED live contract (build this)
Three screens (same glassy AuthCard system, RocGrotesk, ambient glow), mirroring
dwelleo.sa `/en/forget-password`:

1. **Forgot Password** — "Enter your email to receive a verification code";
   email field; primary "Send Verification Code →"; "← Back to Login".
   → `POST /auth/send-otp`  body `{ "email": "...", "type": "reset-password" }`
   (EXACT value captured from the live site — hyphen, NOT `reset_password` /
   `forgot_password`, which the server rejects with "The selected type is
   invalid"). Server RATE-LIMITS this ("Too Many Attempts"). Response returns
   a **`verification_token`** — keep it in cubit state for the next steps.

2. **Enter Verification Code** — "We sent a 4-digit code to <email>"; four 1-char
   OTP boxes (active box = lime border, auto-advance/backspace); a **live resend
   countdown** ("Resend code in 55s" → when it hits 0, becomes tappable "Resend
   Code" in lime); primary "Verify Code →"; "← Change Email".
   → `POST /auth/verify`  body `{ "verification_token": "<from step 1>", "otp": "1234" }`
   Resend = call `POST /auth/send-otp` again (restart the 55s timer, refresh token).

3. **Set New Password** — "Create a strong password"; new password + confirm;
   primary "Reset Password".
   → `POST /auth/reset-password`  body `{ "verification_token": "...",
   "new_password": "...", "new_password_confirmation": "..." }`
   Password rule: upper + lower + digit + **symbol**, min 8.

**Counter must be real, not dead text:** a `Timer.periodic` in the cubit counting
down from 55s (or the value the API implies), disabling Resend until 0, then
re-enabling it and re-calling send-otp. Show `Resend code in {n}s` while >0.

**⚠️ Email delivery is a BACKEND issue:** tested live on dwelleo.sa — the flow
advances (send-otp → verify → reset all 200), but the OTP email does not arrive.
That is dwelleo's server SMTP/mail config, NOT the app. Build the app side to call
these endpoints correctly; flag the email delivery to the backend team. Do not try
to "fix email" in Flutter.

Add `send-otp` / `verify` / `reset-password` to `ApiEndpoints`, build a
`ForgotPasswordCubit` (sealed states: askEmail, codeSent(token,secondsLeft),
verifying, verified, resetting, done, failure) + data source + repository, wire
routes, and link "Forgot password?" on the login screen to screen 1.

### Location picker — website panel design (to match after the crash fix)
The site's "Select Location" modal, top→bottom: title "Select Location" + close;
a **full-width lime "Current Location"** button (target icon); a bordered
**address field** (search icon + resolved address, e.g. "7250, Alsahafa, Riyadh
12251, Saudi Arabia"); an info hint "Move the map to position the pin at the
correct location"; the **map** (rounded) with a fixed centre pin; footer
**Cancel** (outlined) + **Confirm Location** (lime). The crash fix
(`Positioned.fill` map + `IgnorePointer` pin) is already applied — restyle the
chrome to the above.

---

## 0. PRIORITY BUGS (fix first)

### 0.1 Location picker — BLACK SCREEN + layout crash (highest priority)
Debug console on a real device shows:

```
RenderBox was not laid out: RenderMetaData#… NEEDS-LAYOUT NEEDS-PAINT
'package:flutter/src/rendering/box.dart': Failed assertion: line 2251 pos 12: 'hasSize'
Scaffold  …/lib/core/widgets/location_picker.dart:135:12
Exception caught by gestures library …
'…/object.dart': Failed assertion: '!semantics.parentDataDirty': is not true.
```

So the screen is black because of a **layout exception**, not only the Maps key.
The `GoogleMap` platform view is being given **unbounded constraints** by the
`Stack`/`Column` and never gets a size.

**Fix:** give the map an explicitly bounded box and don't rely on `Stack`'s
implicit sizing for the platform view. Concretely in `location_picker.dart`:

- Wrap the `GoogleMap` so it always has a finite size, e.g. inside the `Expanded`
  use `SizedBox.expand(child: GoogleMap(...))`, OR replace the `Stack` body with
  `LayoutBuilder` and pass explicit `width/height` to a `SizedBox` around the map.
- Keep the center pin as a sibling using `Positioned.fill` + `IgnorePointer`
  (the pin must NOT intercept gestures or it re-triggers the hit-test crash).
- Guard `setState` after async gaps with `if (!mounted) return;` (already mostly
  done — keep it).

Reference safe structure:

```dart
Expanded(
  child: Stack(
    children: [
      Positioned.fill(
        child: GoogleMap(
          initialCameraPosition: const CameraPosition(target: _fallback, zoom: 14),
          onMapCreated: (c) => _map = c,
          myLocationButtonEnabled: false,
          onCameraMove: (p) => _center = p.target,
          onCameraIdle: () => _resolve(_center),
        ),
      ),
      const Positioned.fill(
        child: IgnorePointer(
          child: Align(
            alignment: Alignment(0, -0.04),
            child: Icon(Icons.location_on, size: 44),
          ),
        ),
      ),
    ],
  ),
),
```

Verify on a device: no `hasSize` exception in the console, tiles render, X/Confirm work.

### 0.2 Maps render (iOS + Android)
- iOS key in `ios/Runner/AppDelegate.swift` is set to `AIzaSyBOGg7aefYtU8t5GLQWxcEJPjYzYRgWxJo`.
- Google Cloud project `dwelleo-60f38`. The iOS key is **restricted to iOS bundle IDs**.
  The app runs under THREE bundle IDs — add ALL to the key's *iOS app restrictions*:
  - `sa.dwelleo.app` (release)
  - `sa.dwelleo.app.dev`  ← **debug `flutter run` uses this** (the usual reason for the black map)
  - `sa.dwelleo.app.staging`
- Key *API restrictions* must include **Maps SDK for iOS** (and Maps SDK for Android for the Android key).
- **Billing must be enabled** on the project (Maps shows black tiles with NO error if billing is off).
- Android key `AIzaSyC3Y2hQ6rzdKNfIboUXIe07fX3IMu_Pr_Y` in `AndroidManifest.xml`
  (`com.google.android.geo.API_KEY`); restrict to applicationId `sa.dwelleo.app(.dev/.staging)` + SHA-1.
- After changes: `flutter clean && flutter pub get && cd ios && pod install && cd .. && flutter run`
  (native key changes never apply on hot restart).

---

## 1. VERIFIED BACKEND CONTRACT (do not change keys/shapes)

Base URL: `https://api.dwelleo.sa/api/v1`. Standard envelope `{message, data:{…}}`.
Locale via header. Errors come back 422 with `{message, errors:{field:[msg]}}`.

### Login — `POST /auth/login`
```json
{ "email": "user@x.com", "password": "Secret123" }
```
Wrong creds → message "These credentials don't match our records." A freshly
registered account must complete OTP verification before it can log in.

### Register — `POST /auth/register`  (verified via live validation probes)
Required + exact shapes:
```jsonc
{
  "user_type": ["buyer"],            // ARRAY (server: "user type must be an array")
                                     // values: buyer|seller|agent|broker|developer|individual_broker
  "name": "Mohamed",
  "email": "x@y.com",
  "phone": "20-1024353182",          // "<dialcode>-<national digits>", no '+', dash. e.g. 966-5XXXXXXXX
  "password": "Mh@194200",           // needs upper + lower + digit, min 8
  "password_confirmation": "Mh@194200",
  "languages_spoken": [1, 2]         // ARRAY of language IDS from /lookup (English=1, Arabic=2). NOT 'languages'
}
```
Optional: `whatsapp` (same phone format), `city`, `district`, `description`,
`location`, `lat`, `lng`. On success the backend issues an **OTP** (4-digit) →
the app must show the OTP screen and call the verify endpoint.

> ACTION: capture the **OTP verify** endpoint + body from the live flow (DevTools
> Network on dwelleo.sa register → "Verify Code"), e.g. `POST /auth/verify-otp`
> `{ email, code }` or `{ phone, otp }` — confirm exact path/keys, then wire it.

### Lookups — `GET /lookup`
`data.cities` (id+name), `data.languages` (id 1=English, 2=Arabic),
`data.property_types`, `data.amenities`, etc. City dropdown already uses this.

---

## 2. LOGIN SCREEN — EXACT SPEC (captured live, dark mode)

Page background `#1B1B1B` (neutral, no green tint). Content centered, max card width ~480.

| Element | Spec |
|---|---|
| Card | width ≤480, **padding 33px**, radius **24px**, bg `white @10%`, border `1px white @10%`, NO shadow |
| Heading "Welcome Back" | **36px / weight 700**, color `#FFFFFF`, centered |
| Subtitle "Sign in to continue to Dwelleo" | **14px / 400**, color `white @60%`, centered |
| Field label (Email Address / Password) | **14px / 400**, color **`white @60%`** (muted, NOT full white) |
| Input | **height 53**, radius **14**, bg `white @5%`, border `1px white @10%`, content padding `14px 16px 14px 48px` (48px left = leading icon), text white |
| Leading icon (mail/lock) | muted `white @45–60%`, ~18px, inset left |
| Remember Me / Forgot | row, space-between; "Forgot password?" colored with the accent |
| Primary "Sign In →" | full width, **height ~53**, bg **`#D1F145`** (lime), text **`#000000`**, weight 700, radius **14**; disabled = light grey |
| Divider "OR" | hairline `white @10%` both sides, centered label `white @60%` |
| "Continue with Google" | outlined, full width, height ~53, radius 14, border `white @15%`, Google "G" svg + label |
| Footer | "Don't have an account? **Sign Up**" (Sign Up = accent) |

**Accent rule (whole app):** lime `#D1F145` in **dark**, purple `#6B4FA0` in **light**.
Text-on-lime = near-black; text-on-purple = white. Light page `#F6F7F3`, light card
white. In light mode the card is a near-white translucent panel, hairline border.

### Current Flutter gaps to fix on Login
- Heading is too small (app uses ~28; site is **36/700**). Bump it.
- Labels are full-strength; should be **muted `white@60%` / 14**.
- Card padding should be **~32** (set), inputs **~53 tall** (radius 14, glassy) — already themed; verify visually.
- Keep the ambient accent glow backdrop (already added via `AuthBackground`).

---

## 3. SIGN-UP — EXACT STRUCTURE (mirror the site)

Same card system (glassy, radius 24, padding ~32) on the `#1B1B1B` page with the glow.

**Step 1 — Account type** ("Join Dwelleo / Choose your account type to get started"):
6 selectable cards in a 2-col grid: Buyer / Renter, Seller / Rental, Agent, Broker,
Developer, Individual Broker. Selected card = accent border + soft glow + tinted icon.
"Continue →" disabled until one is chosen. Maps to `user_type: [key]`.

**Step 2 — "Join Dwelleo / Fill your information"** with a 2-segment progress bar
("Step 2 of 2 / 100% Complete"). Card title "Personal Information". Fields in order:
Full Name*, Email Address*, Phone Number* (intl field, default SA, hint follows
country), WhatsApp Number, City (dropdown from `/lookup`), District,
**Preferred languages*** (selectable chips → ids), Password*, Confirm Password*,
Description (0/1000), Location (opens map picker), Terms checkbox*. Buttons:
"Previous" (secondary) + "Create Account →" (primary lime). Submit → `/auth/register`.

**Step 3 — OTP / Verification Code:** 4 boxes (active box = accent border), "Resend
Code" (accent), "Verify Code →" (primary, disabled until 4 digits), "← Back to
Login". Style identical to the auth card system. Wire to the OTP verify endpoint
(see §1 ACTION).

### Current Flutter gaps on Sign-up
- "Preferred languages" chips: use clean accent tint when selected (done) — verify.
- "Create Account" button must stay single-line with arrow (done) — verify.
- Ensure payload uses the §1 verified shapes (`user_type` array, `languages_spoken`
  ids, `phone` `<dial>-<number>`) — already implemented in `signup_form_screen.dart`.
- After successful register, navigate to the OTP screen (don't go straight to search).

---

## 4. APP BAR + SCAFFOLD (raise fidelity — currently the weakest part)

dwelleo.sa header: brand wordmark (switches with language + theme), a language
control showing the language you can switch TO (flag + label), a sun/moon pill,
and (on web) an "AI Search" pill. Keep the bar **seamless** with the page color
(`#1B1B1B` dark / `#F6F7F3` light), no shadow, no tint.

Recommendations:
- Verify the app bar background equals the scaffold (no seam) and the wordmark
  asset switches EN/AR + light/dark.
- Auth pages: consider making the bar transparent with `extendBodyBehindAppBar:true`
  so the ambient glow runs to the top edge (test for content overlap first).
- Audit Home / Property list / Property detail against the site next (out of scope
  for this auth-focused pass, but the same token system applies).

---

## 5. DESIGN TOKENS (single source — `lib/core/theme/app_colors.dart`)

```
lime/primary (dark accent)  #D1F145
purple/accent (light accent)#6B4FA0
ink (text on lime)          ~#0A0A0A (use pure black on the lime CTA)
dark page                   #1B1B1B
dark surface/card           #1F1F20 / #242427
dark divider                #333335  (≈ white @10%)
dark text                   #F4F4F5 primary / #A1A1AA secondary
glass card fill             white @10% (dark) / white @70% (light)
glass input fill            white @5%, border white @10%, radius 14
card radius                 24    | button radius 14 | input height ~53
heading                     36/700 | label 14/400 @60% | subtitle 14/400 @60%
```

`AppColors.accentFor(brightness)` / `onAccentFor(brightness)` already encode the
lime/purple flip — use them everywhere, never hardcode.

---

## 6. ACCEPTANCE CRITERIA
1. Location picker opens with NO `hasSize` exception; map tiles render on iOS+Android;
   X closes; "Use Current Location" fills the address; Confirm returns lat/lng.
2. Sign-up (all 6 roles) submits, receives OTP, OTP verify succeeds, account logs in.
3. Login shows field-level red borders + inline message on bad creds; succeeds on good.
4. Login + Sign-up match §2/§3 in BOTH dark/light and EN/AR (RTL), heading 36/700,
   muted labels, glassy inputs, lime CTA (dark) / purple CTA (light).
5. `flutter analyze` clean; no overflow/render exceptions in the console.
