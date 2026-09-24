# Product Catalog App
This is my submission for the Junior Mobile Developer technical assessment at Neurogine. A small product catalog app built with Flutter, using the DummyJSON API.

## About me
Hi, I'm Nur Anis Syakirah, an IT graduate from Universiti Tun Hussein Onn Malaysia (UTHM), currently doing my on-the-job training as a Developer Intern at Adastra IP. I mainly work with PHP/Laravel and Flutter, so I built this app in Flutter as stated in my application.

## How to run
1. Clone this repository
2. Run flutter pub get
3. Start an Android emulator (or connect a physical Android device)
4. Run flutter run

## Stack
1. Framework: Flutter (Dart)
2. State management: provider package (ChangeNotifier + Consumer)
3. HTTP client: http package
4. API: DummyJSON — free, no API key needed

## Architecture
I structured this app using MVVM, organized by feature module rather than by file type. This is the same pattern I've been using at my internship at Adastra IP, so I wanted to apply the same structure here:

lib/
├── app/
│   ├── common/
│   │   └── utils/debouncer.dart      # shared debounce helper for search
│   ├── module/
│   │   └── product/
│   │       ├── model/                # Product, ProductListResponse, Category
│   │       ├── services/             # ProductService — all HTTP calls
│   │       ├── view model/           # ProductListViewModel, ProductDetailViewModel
│   │       └── view/                 # screens + widget/ (reusable UI pieces)
│   └── main.dart

The idea is each layer only does one job:

1. model — just defines what the data looks like
2. services — the only layer that talks to the DummyJSON API
3. view model — holds the state (loading, error, products, pagination) and the logic for what to do with it
4. view — just UI. It reads from the view model and calls its methods, it never calls the API directly

## Decisions
a) Pagination — page-based (Previous/Next) instead of infinite scroll. I went with a "1-20 of 194" style indicator with Previous/Next buttons instead of loading more as you scroll. I felt this gives clearer, more predictable state — you always know exactly what page you're on, instead of managing a growing list with a scroll listener.

b) Search — server-side, debounced. Search calls the actual /products/search?q= endpoint instead of just filtering whatever's already loaded, so it searches the whole catalog, not just the current page. I added a 500ms debounce so it doesn't call the API on every single keystroke while typing.

c) Category filter — server-side, via /products/category/{slug}. I originally tried filtering categories client-side on whatever products were already loaded, but that broke — if a category wasn't in the current page, it would just show empty. So I switched to calling DummyJSON's dedicated category endpoint instead, which is properly paginated per category.

d) Filter UI — bottom sheet instead of a fixed tab bar. I initially had the categories as a horizontal chip row under the search bar, but DummyJSON has more categories than can comfortably fit in one row without overflowing. So I moved it into a scrollable bottom sheet, opened via the filter icon next to the search bar.

## TODO
 Product list screen — thumbnail, title, price per product
 Pagination — page-based, using skip/limit, with a "X-Y of Total" indicator and Previous/Next buttons
 Product detail screen — description, price, rating, images, plus extra fields the API provides (brand, stock, discount, tags, SKU, warranty, shipping, return policy)
 Four distinct states — loading, error with retry, empty, success
 Search — debounced, server-side
 Category filter — server-side, with a clearable chip showing the active filter
 Code split into 4 layers — model / services / view model / view
 Navigation from the list screen to the detail screen
 Pull-to-refresh
 Unit tests
 Image loading only has a basic fallback (a broken-image icon on error) — no custom placeholder or shimmer effect while loading
 No local caching — the app re-fetches from the API every time
## About me
## About me

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
