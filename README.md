# Product Catalog App
This is my submission for the Junior Mobile Developer technical assessment at Neurogine. This is a simple product catalog app built using Flutter and the DummyJSON API.

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
The architecture used on this project is MVVM concept. I organized the code based on features instead of grouping files by type.This is the same structure that I have used during my internship and on-the-job training, so I decided to use the same approach for this assessment. Each part has its own responsibility:

1. Model — Defines the structure of the product data.
2. Services — Handles communication with the DummyJSON API.
3. View Model — Manages the app state such as loading, errors, products, pagination, and the related logic.
4. View — Handles the UI. It gets the data from the View Model and calls its methods. It does not call the API directly.

lib/
├── app/
│   ├── common/
│   │   └── debouncer.dart     
│   ├── module/
│   │   └── product/
│   │       ├── model/          
│   │       ├── services/       
│   │       ├── view model/           
│   │       └── view/                 
│   └── main.dart

## Decisions
1. Pagination — page numbers instead of infinite scroll.
I used page numbers instead of infinite scroll. The product list shows an indicator such as "1-20 of 194" with Previous and Next buttons. I chose this approach because it makes the user's current position in the product list clear. It also avoids the extra complexity of continuously loading more products when the user scrolls.

2. Search — server-side search with debounce.
The search function uses the DummyJSON search endpoint (/products/search?q=). The app waits for 500ms after the user stops typing before sending the request. I used this approach so that the search can cover the full product catalog instead of only the products currently loaded on the page. The debounce also helps reduce the number of API requests because a request is not sent for every keystroke.

3. Category filter — Server-Side Filtering.
At first, I filtered the products that were already loaded on the current page. However, this caused a problem when a category was not available on the current page. The app would show an empty list even though products from that category existed on other pages. To solve this, I changed the implementation to use DummyJSON's category endpoint directly (/products/category/{slug}). This allows the app to get the products for the selected category directly and display the correct paginated results.

4. Filter UI — bottom sheet instead of a chip row.
At first, I displayed the categories as a horizontal row of chips below the search bar. However, DummyJSON has several categories, so they could not fit properly in one row and caused a layout overflow. I changed the category filter to a scrollable bottom sheet. Users can open it by tapping the filter icon beside the search bar. This makes the filter easier to use and also avoids the layout overflow issue.

## TODO
 ✅Product list screen — thumbnail, title, price per product
 ✅Pagination — page-based, using skip/limit, with a "X-Y of Total" indicator and Previous/Next buttons
 ✅Product detail screen — description, price, rating, images, plus extra fields the API provides (brand, stock, discount, tags, SKU, warranty, shipping, return policy)
 ✅Four distinct states — loading, error with retry, empty, success
 ✅Search — debounced, server-side
 ✅Category filter — server-side, with a clearable chip showing the active filter
 ✅Code split into 4 layers — model / services / view model / view
 ✅Navigation from the list screen to the detail screen
 ❌Pull-to-refresh
 ❌Unit tests
 ❌Image loading only has a basic fallback (a broken-image icon on error) — no custom placeholder or shimmer effect while loading
 ❌No local caching — the app re-fetches from the API every time
