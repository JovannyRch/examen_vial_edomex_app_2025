# Potential Features for Examen Vial EdoMéx App

## Core Study Enhancements

### 1. Road Sign Recognition Quiz (Implemented ✓)
Image-based identification game where users see a sign image and must identify its meaning from multiple choice options. Categories: preventive, restrictive, informational. Includes a "Speed Round" mode with timer pressure.

### 2. Weak Areas Identification (Implemented ✓)
Automatically detect questions categories where the user consistently fails. Display a "Areas de oportunidad" section highlighting the weakest categories with suggested targeted practice.

### 3. Spaced Repetition System (Implemented ✓)
Prioritize questions answered incorrectly for future practice sessions. Uses an algorithm to schedule difficult questions more frequently. Creates a "Repasar" (Review) queue based on historical performance.

### 4. Interactive Traffic Map
Visual map embedded in Info screen showing nearby licensing office locations in Estado de México. Uses static map image with clickable markers linking to Google Maps directions.

---

## Engagement Features

### 5. Daily Challenge
A single daily question challenge with a streak counter. Resets at midnight. Includes a leaderboard of users who completed today's challenge. Bonus: share daily result as image to social media.

### 6. Study Groups / Shareable Question Sets
Create and share custom exam sets with friends. Export/import question sets via deep link or share code. Social comparison of scores within friend groups.

### 7. Voice Reading (Text-to-Speech)
Read questions and answers aloud using device TTS engine. Toggle in exam/guide mode. Particularly useful for users who prefer auditory learning or have reading difficulties.

### 8. Widget of the Day
Android home screen widget showing a daily practice question. Tapping opens directly to that question in guide mode. Shows streak of consecutive days practiced.

---

## Monetization (Pro Enhancements)

### 9. Offline Mode
Download all questions and PDFs for offline access. Sync progress when connection restored. Queue-based sync for exam results taken offline.

### 10. Custom Exams Builder (Implemented ✓)
Create custom exam sessions by selecting specific categories, difficulty, and question count. Save custom exams as presets. Share presets with other users.

### 11. Export Results as PDF
Generate a PDF report of exam history and progress. Includes charts, statistics, and achievement summary. Useful for personal records or sharing with driving school instructors.

### 12. Advanced Statistics Dashboard
Deeper analytics: time-of-day performance patterns, difficulty curve analysis, category mastery heatmap, prediction of exam readiness score.

---

## User Experience Polish

### 13. Onboarding Flow
First-time user tutorial explaining all app features. Highlights Pro benefits, notification setup prompt, and study streak importance. Skippable but stored to never show again.

### 14. Haptic Feedback (Implemented ✓)
Vibration feedback on button presses, correct/incorrect answers, and achievement unlocks.

### 15. Sound Packs
Alternative sound themes (realistic engine sounds, calm/zen, achievement fanfares). Settings-based selection.

### 16. Dark Mode Improvements
Add auto theme switching based on device settings (follow system). Add AMOLED black pure dark mode option. Custom accent color picker for Pro users.

---

## Content Expansion

### 17. Video Lessons
Embedded YouTube videos explaining traffic rules, sign meanings, and exam tips. Integration via youtube_player_flutter. Categorized playlist section.

### 18. Traffic Law PDF Summary
A condensed, searchable PDF summary of key traffic laws. Highlight and bookmark functionality. Search within PDF.

### 19. Exam Simulator with Timed Voice Prompts
Simulate real exam conditions: voice reads each question aloud, auto-advances after timeout. Mimics the actual DMV exam experience more closely.

---

## Platform-Specific

### 20. App Clips / Instant App
Lightweight quick-demo version for Android. Allows trying a 3-question sample exam without full install.

### 21. Apple Watch Companion
WatchOS app showing daily streak and quick stats. Complication for fast access to widget of the day.

### 22. Siri Shortcuts / Google Assistant Integration
Voice command: "Hey Siri,/start my driving practice" opens the app to quick exam. Routine integration for daily reminder customization.

---

## Technical / Infrastructure

### 23. Cloud Sync
Cross-device synchronization of progress, favorites, achievements, review queue, and weak areas using Supabase Auth + Postgres. Login optional but enables backup.

### 24. A/B Testing Framework
Test different UI layouts, onboarding flows, or exam algorithms with user groups. Firebase Remote Config for feature flags.

### 25. Analytics Dashboard (Developer)
Track user cohort retention, funnel drop-off rates, most failed questions globally (aggregated/anonymized). Heat map of weak areas across all users.

### 26. Crash Reporting & Error Tracking
Production-grade monitoring via Firebase Crashlytics or Sentry. Real-time alerts for app stability issues.

### 26.1 Supabase Auth Foundation (Implemented ✓)
Optional Supabase authentication with silent anonymous sign-in and email upgrade. Enables future cloud sync, reports, tips, voting, and leaderboards without forcing users to create an account upfront.

---

## Community & Social

### 27. Anonymous Leaderboard
Weekly/monthly rankings by exam pass rate and streak. Leaderboard categories: all users, friends only, regional.

### 28. User Reports / Flag Questions
Allow users to report questions with errors or outdated information. Admin dashboard for reviewing reports and pushing corrections via remote config.

### 29. Community Tips Section
User-submitted exam tips and tricks backed by Supabase. Upvote/downvote system, pending/approved/rejected moderation states, category filters, and local reporting for low-quality tips.

### 30. Remote Question Updates
Use Supabase to publish corrected or newly added exam questions without requiring an app update. Includes versioning, active/inactive status, category tags, explanations, and optional image URLs.

### 31. Question Reports & Admin Review (Implemented ✓)
Let users report confusing, outdated, or incorrect questions. Store reports in Supabase with device/user metadata, question ID, reason, and status so an admin can review and resolve them. Includes a reusable in-app report sheet and Supabase table/RLS setup for admin review workflows.

### 32. Anonymous Community Insights
Aggregate anonymized exam performance in Supabase to show globally difficult categories/questions. Could power messages like "Esta pregunta la falla mucha gente" or a developer dashboard of most-missed questions.

### 33. Public Leaderboards
Weekly/monthly anonymous rankings by streak, exam score, or sign quiz score using Supabase tables and row-level security. Optional display name, no personal data required.

---

## Priority Recommendation

| Priority | Feature | Reason |
|----------|---------|--------|
| 🔴 High | Spaced Repetition | Directly improves learning outcomes |
| 🔴 High | Weak Areas ID | Clear value add, already have data |
| 🟡 Medium | Offline Mode | Major Prodifferentiator |
| 🟡 Medium | Custom Exams | Good for Pro tier |
| 🟡 Medium | Supabase Community Tips | Adds useful community value once backend is connected |
| 🟡 Medium | Remote Question Updates | Lets content improve without Play Store releases |
| 🟢 Low | Video Lessons | Content-heavy, requires ongoing effort |
| 🟢 Low | Cloud Sync | Easier once Supabase Auth/Postgres is configured |
