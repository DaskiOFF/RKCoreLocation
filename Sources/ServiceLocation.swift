import CoreLocation

public enum ServiceLocationAccuracy {
    case bestForNavigation, best, nearestTenMeters, hundredMeters, kilometer, threeKilometers

    public var rawValue: Double {
        switch self {
        case .bestForNavigation:
            return kCLLocationAccuracyBestForNavigation
        case .best:
            return kCLLocationAccuracyBest
        case .nearestTenMeters:
            return kCLLocationAccuracyNearestTenMeters
        case .hundredMeters:
            return kCLLocationAccuracyHundredMeters
        case .kilometer:
            return kCLLocationAccuracyKilometer
        case .threeKilometers:
            return kCLLocationAccuracyThreeKilometers
        }
    }
}

public enum ServiceLocationAuthorizationStatus {
    case authorizedAlways
    case authorizedWhenInUse
    case notDetermined
    case denied
}

public enum RequestType {
    case whenInUseAuth, alwaysAuth
}

public protocol ServiceLocation {
    // MARK: - Types
    typealias DidChangeAuthorizationStatus = (ServiceLocationAuthorizationStatus) -> Void
    typealias DidUpdateLocation = (CLLocation) -> Void
    typealias Seconds = Int
    typealias BlockCompletion = (CLLocation?) -> Void

    // MARK: - Callbacks
    func setDidChangeAuthorizationStatus(_ block: DidChangeAuthorizationStatus?)
    func setDidUpdateLocation(_ block: DidUpdateLocation?)

    // MARK: - Authorization
    func requestAuth(requestType: RequestType)
    func requestAuth(requestType: RequestType, accuracy: ServiceLocationAccuracy)

    // MARK: - Setters
    func set(accuracy: ServiceLocationAccuracy)

    // MARK: - Last Position
    func getLastPosition(timeout: Seconds, completion: @escaping BlockCompletion)

    // MARK: - Updating
    func startUpdating()
    func stopUpdating()
}
