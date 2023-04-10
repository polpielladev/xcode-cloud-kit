import XCTest
@testable import XcodeCloudKit

final class ProductTests: XCTestCase {
    func test_GivenAProductExists_WhenStartWorkflowIsCalled_ThenClientRequestIsMade() async throws {
        let client = SpyAppStoreConnectAPIClient()
        
        try await client.startWorkflow(with: "workflow-id", at: "git-ref-id")
        
        XCTAssertEqual(client.capturedStartWorkflowCalls[0].id, "workflow-id")
        XCTAssertEqual(client.capturedStartWorkflowCalls[0].gitReferenceId, "git-ref-id")
    }
    
    func test_GivenAWorkflowIsReturnedInResponse_ThenProductIsMappedCorrectly() async throws {
        let client = SpyAppStoreConnectAPIClient()
        client.workflowsResponseToReturn = MockWorkflowsResponseBuilder()
            .with(id: "id")
            .with(name: "name")
            .build()
        let product = Product(name: "", id: "id", repository: .init(id: "", name: ""), client: client)
        
        let workflows = try await product.workflows()
        
        XCTAssertEqual(workflows.count, 1)
        XCTAssertEqual(workflows.first?.id, "id")
        XCTAssertEqual(workflows.first?.name, "name")
    }
}
