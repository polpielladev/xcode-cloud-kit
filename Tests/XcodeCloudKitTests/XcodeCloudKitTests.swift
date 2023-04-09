import XCTest
@testable import XcodeCloudKit
import AppStoreConnect_Swift_SDK

class MockAppStoreConnectAPIClient: AppStoreConnectAPIClient {
    var productsResponseToReturn: CiProductsResponse?
    func allProducts() async throws -> CiProductsResponse {
        try XCTUnwrap(productsResponseToReturn)
    }
}

final class XcodeCloudKitTests: XCTestCase {
    func test_GivenASCClientReturnsProductWithNoRepository_ThenProductIsNotInTheArray() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        client.productsResponseToReturn = noRepositoriesProductResponse()
        
        let products = try await sut.allProducts()
        
        XCTAssertTrue(products.isEmpty)
    }
    
    private func noRepositoriesProductResponse() -> CiProductsResponse {
        return CiProductsResponse(data: [
            .init(
                type: .ciProducts,
                id: "no-repositories",
                attributes: .init(name: "No Repositories Response"),
                links: .init(this: ""))
        ], links: .init(this: ""))
    }
}
