import XCTest
@testable import XcodeCloudKit
import AppStoreConnect_Swift_SDK

class MockAppStoreConnectAPIClient: AppStoreConnectAPIClient {
    var productsResponseToReturn: CiProductsResponse?
    func allProducts() async throws -> CiProductsResponse {
        try XCTUnwrap(productsResponseToReturn)
    }
    
    var productResponseToReturn: CiProductResponse?
    func product(id: String) async throws -> CiProductResponse {
        try XCTUnwrap(productResponseToReturn)
    }
}

final class XcodeCloudKitTests: XCTestCase {
    // MARK: - All products
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
    
    // MARK: - Product by id
    func test_GivenASCClientReturnsProductByIdWithNoRepository_ThenProductIsNotReturned() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        let responseBuilder = MockProductResponseBuilder()
            .with(id: "product-id")
            .with(name: "product-name")

        client.productResponseToReturn = responseBuilder.build()
        let product = try await sut.product(withId: "product-id")
        
        XCTAssertNil(product)
    }
    
    func test_GivenASCClientReturnsProductWithNoName_ThenProductIsNotReturned() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        let responseBuilder = MockProductResponseBuilder()
            .with(id: "product-id")
            .with(repositoryName: "repo-name", repositoryId: "repo-id")
        client.productResponseToReturn = responseBuilder.build()
        
        let product = try await sut.product(withId: "product-id")
        
        XCTAssertNil(product)
    }
    
    func test_GivenASCClientFindsProductById_ThenProductIsReturned() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        let responseBuilder = MockProductResponseBuilder()
            .with(id: "product-id")
            .with(name: "product-name")
            .with(repositoryName: "repo-name", repositoryId: "repo-id")

        client.productResponseToReturn = responseBuilder.build()
        
        let product = try await sut.product(withId: "product-id")
        
        XCTAssertEqual(product?.id, "product-id")
        XCTAssertEqual(product?.name, "product-name")
        XCTAssertEqual(product?.repository.name, "repo-name")
        XCTAssertEqual(product?.repository.id, "repo-id")
    }
    
    // MARK: - Product by name
    func test_GivenASCClientReturnsProductWithExpectedNameInList_ThenProductIsReturned() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        let responseBuilder = MockProductsResponseBuilder()
            .with(id: "product-id")
            .with(name: "product-name")
            .with(repositoryName: "repo-name", repositoryId: "repo-id")

        client.productsResponseToReturn = responseBuilder.build()
        
        let product = try await sut.product(withName: "product-name")
        
        XCTAssertEqual(product?.id, "product-id")
        XCTAssertEqual(product?.name, "product-name")
        XCTAssertEqual(product?.repository.name, "repo-name")
        XCTAssertEqual(product?.repository.id, "repo-id")
    }
    
    func test_GivenASCClientProductResponseDoesNotReturnProductWithName_WhenXcodeCloudKitRequestsProduct_ThenProductIsNil() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        let responseBuilder = MockProductsResponseBuilder()
            .with(id: "product-id")
            .with(name: "product-name")
            .with(repositoryName: "repo-name", repositoryId: "repo-id")
        client.productsResponseToReturn = responseBuilder.build()
        
        let product = try await sut.product(withName: "not-found")
        
        XCTAssertNil(product)
    }
    
    // MARK: - Product from repository
    func test_GivenASCClientReturnsProductWithExpectedRepositoryInList_ThenProductIsReturned() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        let responseBuilder = MockProductsResponseBuilder()
            .with(id: "product-id")
            .with(name: "product-name")
            .with(repositoryName: "repo-name", repositoryId: "repo-id")

        client.productsResponseToReturn = responseBuilder.build()
        
        let product = try await sut.product(fromRepository: "repo-name")
        
        XCTAssertEqual(product?.id, "product-id")
        XCTAssertEqual(product?.name, "product-name")
        XCTAssertEqual(product?.repository.name, "repo-name")
        XCTAssertEqual(product?.repository.id, "repo-id")
    }
    
    func test_GivenASCClientProductResponseDoesNotReturnProductWithExpectedRepositoryInList_WhenXcodeCloudKitRequestsProduct_ThenProductIsNil() async throws {
        let client = MockAppStoreConnectAPIClient()
        let sut = DefaultXcodeCloudKit(client: client)
        let responseBuilder = MockProductsResponseBuilder()
            .with(id: "product-id")
            .with(name: "product-name")
            .with(repositoryName: "repo-name", repositoryId: "repo-id")
        client.productsResponseToReturn = responseBuilder.build()
        
        let product = try await sut.product(fromRepository: "not-found")
        
        XCTAssertNil(product)
    }
}
