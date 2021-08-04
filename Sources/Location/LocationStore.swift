import Combine
import CoreLocation

public class LocationManager: NSObject, ObservableObject{
    @Published
    public var location: CLLocation = .init()

    private let locationManager = CLLocationManager()

    public init(accuracy: CLLocationAccuracy = kCLLocationAccuracyKilometer) {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = accuracy
    }

    public func requestAuthorization() {
        self.locationManager.requestWhenInUseAuthorization()
    }

    public func startMonitoring() {
        self.locationManager.startUpdatingLocation()
    }

    public func stopMonitoring() {
        self.locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    public func locationManager(_ manager: CLLocationManager,
                                didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
    }
}
