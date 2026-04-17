# Maddad'gar (as_pass)

A Flutter app for hyperlocal service discovery. Users can find nearby service providers, chat in real time, and providers can publish and manage their own skills.

## Overview

Maddad'gar connects customers with local workers such as tutors, technicians, cleaners, electricians, and similar service providers.

Main capabilities:
- Email/password authentication with Supabase Auth
- Hyperlocal discovery using device GPS and distance-based search
- Expandable search radius (1 km up to 50 km)
- Provider profile, ratings, and review submission
- Real-time chat between customer and provider
- Add, edit, and delete provider service listings

## Tech Stack

- Flutter (Dart SDK ^3.8.1)
- GetX for state management and dependency injection
- Supabase (Auth + PostgreSQL + realtime streams)
- Geolocator for location permission and GPS
- flutter_map + latlong2 for map/location picker support
- flutter_dotenv for environment-based configuration

## Project Structure

```text
lib/
  main.dart                  # App bootstrap, env loading, Supabase init
  api/                       # Auth API wrappers
  controller/                # Business logic (GetX controllers)
  home/                      # Home feed screen
  models/                    # Domain models (service/review/category)
  services/                  # Supabase service bootstrap
  ui/                        # App screens (auth, inbox, chat, profile)
  widgets/                   # Reusable widgets + service forms + map picker
  utils/                     # Shared UI helpers
```

## Architecture

The app follows a practical layered structure:

1. UI Layer
   - Screens and widgets in `ui/`, `home/`, and `widgets/`
2. Controller Layer
   - GetX controllers in `controller/` handle state and workflows
3. Data Layer
   - Supabase API calls through `supabase_flutter` client

Common flow example:
- Home screen requests location permission
- Controller gets current coordinates
- Supabase RPC `get_nearby_services_v4` returns nearby providers
- UI reacts through observable state (`Obx`)

## Prerequisites

- Flutter SDK installed and on PATH
- A configured Supabase project
- Android Studio / Xcode (for mobile builds)
- A real or virtual device with location services enabled

## Environment Configuration

Create a `.env` file in the project root:

```env
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

The app loads this file at startup in `lib/main.dart`.

Important:
- Keep `.env` out of source control
- Rotate keys immediately if they were ever exposed

## Supabase Setup

This project expects at least the following database objects:
- `users`
- `services`
- `chat_rooms`
- `messages`
- `reviews`
- view: `user_chat_links`
- rpc function: `get_nearby_services_v4`

### Auth Trigger (required)

Run this SQL so every new auth user is mirrored into `public.users`:

```sql
create function public.add_new_user()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  insert into public.users (id, metadata, email)
  values (new.id, new.raw_user_meta_data, new.email);
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.add_new_user();
```

Note:
- The app stores service location as PostGIS-compatible text (`POINT(long lat)`).
- Ensure your schema and RPC/view signatures match the names used in controllers.

## Getting Started

1. Install dependencies

```bash
flutter pub get
```

2. Ensure `.env` exists with valid Supabase credentials

3. Run the app

```bash
flutter run
```

## Useful Commands

```bash
flutter pub get
flutter run
flutter test
flutter analyze
flutter clean

# Release builds
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web --release
```

## Product Behavior Notes

- Search starts at 1 km and expands in +5 km steps up to 50 km.
- Chat messages use Supabase realtime streams.
- Reviews are submitted/updated with upsert logic.
- Provider profile page supports service CRUD operations.

## Known Limitations

- Some debug `print` logs remain in controllers.
- A few TODO markers exist in UI/controller code.
- Password validation currently focuses on minimum length.
- Production release signing and final package IDs should be reviewed before store deployment.

## Security Recommendations

- Keep Row Level Security (RLS) enabled in Supabase.
- Add strict policies per table (`users`, `services`, `messages`, `reviews`).
- Avoid shipping debug signing for release builds.
- Never expose service-role keys in the client app.

## License

This project currently has no explicit license file.
Add a `LICENSE` file before public distribution.
