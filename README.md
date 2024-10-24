
# Stop Finder

Stop Finder is a Flutter application that helps users find nearby bus stops and get real-time updates on bus arrivals. The app uses the BLoC pattern for state management and integrates with map and location services.

<h3>Features</h3>

Real-Time Bus Arrival Updates: Get real-time information about bus arrivals at nearby stops.
Interactive Map: View your current location and nearby bus stops on an interactive map.
Geolocation: Automatically fetches and displays nearby bus stops based on your current location.
Stop Details: View detailed information about a selected bus stop, including bus routes and arrival times.

<h3>Screenshots</h3>

<p align="center">
  <img src="https://github.com/user-attachments/assets/87e07435-a7fd-42df-9f1b-4c1e04c1a432" width="30%" />
  <img src="https://github.com/user-attachments/assets/434e8054-c121-434a-8068-3ff398232cac" width="30%" />
  <img src="https://github.com/user-attachments/assets/2cbfbd91-4f17-456c-90eb-228144ab94a8" width="30%" />
</p>

<p align="center">
  <img src="https://github.com/user-attachments/assets/d7fbbf77-a150-44fb-9ed6-08678ecffb87" width="30%" />
  <img src="https://github.com/user-attachments/assets/b6b38ec4-1a32-4c6c-828c-72891a6b68b5" width="30%" />
  <img src="https://github.com/user-attachments/assets/314a1882-d8f2-40ad-b9cb-318e584c1209" width="30%" />
</p>

<h3>Installation</h3>

1) Clone the repository:

```shell
git clone https://github.com/manthmn/stop_finder.git
cd stop_finder
```

2) Install dependencies:
```shell
flutter pub get
```

3) Run the application:
```shell
flutter run
```

<h3>Usage</h3>

1) Grant Location Permissions: The app requires location permissions to fetch and display nearby bus stops. Make sure to grant the necessary permissions when prompted.

2) View Nearby Stops: The app will automatically display nearby bus stops on the map based on your current location.

3) Select a Stop: Tap on a bus stop marker on the map to view detailed information about the stop, including bus routes and arrival times.

<h3>API Integration</h3>

Stop Finder uses UK open data to provide information about bus stops and arrival times. The data is fetched from open APIs [api-portal.tfl.gov.uk](https://api-portal.tfl.gov.uk/api-details#api=StopPoint), ensuring that users get accurate and up-to-date information.

<h3>Project Structure</h3>

```shell
lib/
├── blocs/                # BLoC files for managing state
├── constants/            # Constant values used across the app
├── models/               # Data models
├── repository/           # Data repositories
├── screens/              # UI screens
└── main.dart             # App entry point
```

<h3>Dependencies</h3>

`flutter_bloc`
`flutter_map`
`geolocator`
`geocoding`
`permission_handler`
`shimmer`
`latlong2`
`http`
`location`
`logger`

<h3>Contact</h3>

For any questions or suggestions, feel free to contact Manthan Nagina at manthannagina@gmail.com.
