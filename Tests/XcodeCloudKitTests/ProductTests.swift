import XCTest
@testable import XcodeCloudKit

final class ProductTests: XCTestCase {
    func test_GivenAWorkflowIsReturnedInResponse_ThenProductIsMappedCorrectly() async throws {
        let response = MockWorkflowsResponseBuilder()
            .with(id: "id")
            .with(name: "name")
            .build()
        let client = MockAuthenticatedClient(responseToReturn: response)
        let product = Product(name: "", id: "id", repository: .init(id: "", name: ""), client: client)
        
        let workflows = try await product.workflows()
        
        XCTAssertEqual(workflows.count, 1)
        XCTAssertEqual(workflows.first?.id, "id")
        XCTAssertEqual(workflows.first?.name, "name")
    }
}
