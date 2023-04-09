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
        let responseBuilder = MockProductsResponseBuilder()
            .with(name: "product-name")

        client.productsResponseToReturn = responseBuilder.build()
        
        let products = try await sut.allProducts()
        
        XCTAssertTrue(products.isEmpty)
    }
    
    func test_GivenASCClientReturnsProductWithNoName_ThenProductIsNotInTheArray() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        let responseBuilder = MockProductsResponseBuilder()
            .with(repositoryName: "repo-name", repositoryId: "repo-id")
        client.productsResponseToReturn = responseBuilder.build()
        
        let products = try await sut.allProducts()
        
        XCTAssertTrue(products.isEmpty)
    }
    
    func test_GivenASCClientReturnsProductWithAllRequiredFields_ThenProductIsIncludedInTheArray() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        let responseBuilder = MockProductsResponseBuilder()
            .with(id: "product-id")
            .with(name: "product-name")
            .with(repositoryName: "repo-name", repositoryId: "repo-id")

        client.productsResponseToReturn = responseBuilder.build()
        
        let products = try await sut.allProducts()
        
        XCTAssertEqual(products[0].id, "product-id")
        XCTAssertEqual(products[0].name, "product-name")
        XCTAssertEqual(products[0].repository.name, "repo-name")
        XCTAssertEqual(products[0].repository.id, "repo-id")
    }
}
