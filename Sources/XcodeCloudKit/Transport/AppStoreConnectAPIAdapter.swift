import AppStoreConnect_Swift_SDK

class AppStoreConnectSDKAdapter: AuthenticatedTransport {
    private let appStoreConnectSDK: APIProvider
    
    init(appStoreConnectSDK: APIProvider) {
        self.appStoreConnectSDK = appStoreConnectSDK
    }
    
    func perform<T>(request: TransportRequest<T>) async throws -> T where T : Decodable {
        return try await appStoreConnectSDK.request(Request<T>(method: request.method, path: request.path, query: request.queryParameters))
    }
}
