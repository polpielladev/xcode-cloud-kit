@testable import XcodeCloudKit
import XCTest

class MockAuthenticatedClient<ResponseType: Decodable>: AuthenticatedTransport {
    
    var capturedRequests = [TransportRequest<ResponseType>]()
    private let responseToReturn: ResponseType
    
    init(responseToReturn: ResponseType) {
        self.responseToReturn = responseToReturn
    }
    
    func perform<T: Decodable>(request: TransportRequest<T>) async throws -> T {
        guard let request = request as? TransportRequest<ResponseType> else {
            fatalError("Request types don't match!")
        }
        
        capturedRequests.append(request)
        return responseToReturn as! T
    }
}
