import AppStoreConnect_Swift_SDK

class AppStoreConnectSDKAdapter: AppStoreConnectAPIClient {
    private let appStoreConnectSDK: APIProvider
    
    init(appStoreConnectSDK: APIProvider) {
        self.appStoreConnectSDK = appStoreConnectSDK
    }
    
    func allProducts() async throws -> CiProductsResponse {
        let productsEndpoint = APIEndpoint
            .v1
            .ciProducts
            .get(parameters: .init(include: [.primaryRepositories]))
    
        
        return try await appStoreConnectSDK.request(productsEndpoint)
    }
    
    func product(id: String) async throws -> CiProductResponse {
        let productEndpoint = APIEndpoint
            .v1
            .ciProducts
            .id(id)
            .get(parameters: .init(include: [.primaryRepositories]))
        
        return try await appStoreConnectSDK.request(productEndpoint)
    }
}
