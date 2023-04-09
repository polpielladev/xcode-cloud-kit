import AppStoreConnect_Swift_SDK

class AppStoreConnectSDKAdapter: AppStoreConnectAPIClient {
    private let appStoreConnectSDK: APIProvider
    
    init(appStoreConnectSDK: APIProvider) {
        self.appStoreConnectSDK = appStoreConnectSDK
    }
    
    func allProducts() async throws -> CiProductsResponse {
        let producstEndpoint = APIEndpoint
            .v1
            .ciProducts
            .get(parameters: .init(filterProductType: [.app], include: [.primaryRepositories]))
    
        
        return try await appStoreConnectSDK.request(producstEndpoint)
    }
}
