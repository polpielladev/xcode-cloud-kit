@testable import XcodeCloudKit
import XCTest

class SpyAuthenticatedTransport<T: Decodable>: AuthenticatedTransport {

    var capturedRequests = [TransportRequest<T>]()
    var responseToReturn: T?
    func perform<T: Decodable>(request: TransportRequest<T>) async throws -> T {
        capturedRequests.append(request)
        return try XCTUnwrap(responseToReturn)
    }
}
