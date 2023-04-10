import AppStoreConnect_Swift_SDK

protocol AppStoreConnectAPIClient {
    func allProducts() async throws -> CiProductsResponse
    func product(id: String) async throws -> CiProductResponse
}
