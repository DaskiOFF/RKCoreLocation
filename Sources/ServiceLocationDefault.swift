import Foundation
import CoreLocation

enum RequestType {
    case whenInUseAuth, alwaysAuth
}

class ServiceLocationDefault: NSObject, ServiceLocation, CLLocationManagerDelegate {
    // MARK: - Properties
    private let locationManager = CLLocationManager()
    private let updQueue = DispatchQueue(label: "com.waydeveloper.serviceLocation")

    private(set) var didChangeAuthorizationStatus: DidChangeAuthorizationStatus?
    private(set) var didUpdateLocation: DidUpdateLocation?

    private var lastPosition: CLLocation?
    private var workItemLastLocation: DispatchWorkItem?

    // MARK: - Setters
    func setDidChangeAuthorizationStatus(_ block: DidChangeAuthorizationStatus?) {
        didChangeAuthorizationStatus = block
    }

    func setDidUpdateLocation(_ block: DidUpdateLocation?) {
        didUpdateLocation = block
    }

    // MARK: - Init
    override init() {
        super.init()
        locationManager.delegate = self
    }

    // MARK: - Request
    func requestAuth(requestType: RequestType) {
        requestAuth(requestType: requestType, accuracy: .kilometer)
    }

    func requestAuth(requestType: RequestType, accuracy: ServiceLocationAccuracy) {
        guard CLLocationManager.authorizationStatus() == .notDetermined else { return }

        switch requestType {
        case .alwaysAuth:
            locationManager.requestAlwaysAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }

        locationManager.desiredAccuracy = accuracy.rawValue
    }

    func set(accuracy: ServiceLocationAccuracy) {
        locationManager.desiredAccuracy = accuracy.rawValue
    }

    func getLastPosition(timeout: ServiceLocation.Seconds,
                         completion: @escaping ServiceLocation.BlockCompletion) {
        workItemLastLocation = DispatchWorkItem(block: { [weak self] in
            DispatchQueue.main.async { [weak self] in
                guard let sself = self else { return }
                completion(sself.lastPosition)
            }
        })

        guard let workItem = workItemLastLocation else { return }
        updQueue.asyncAfter(deadline: .now() + TimeInterval(timeout), execute: workItem)

        locationManager.requestLocation()
    }

    func startUpdating() {
        locationManager.startUpdatingLocation()
    }

    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }

    // MARK: - CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let position = locations.last else { return }

        lastPosition = position
        didUpdateLocation?(position)

        if let workItem = workItemLastLocation {
            workItem.perform()
            workItem.cancel()
            workItemLastLocation = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("LocationManager did fail with error: \(error)")
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        let outputStatus: ServiceLocationAuthorizationStatus
        switch status {
        case .authorizedAlways:
            outputStatus = .authorizedAlways
        case .authorizedWhenInUse:
            outputStatus = .authorizedWhenInUse
        case .restricted, .denied:
            outputStatus = .denied
        case .notDetermined:
            outputStatus = .notDetermined
        }

        didChangeAuthorizationStatus?(outputStatus)
    }
}
