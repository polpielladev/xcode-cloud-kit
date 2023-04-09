import AppStoreConnect_Swift_SDK

protocol AppStoreConnectAPIClient {
    func allProducts() async throws -> CiProductsResponse
}
