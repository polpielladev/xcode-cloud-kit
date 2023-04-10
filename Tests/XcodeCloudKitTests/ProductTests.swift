import XCTest
@testable import XcodeCloudKit

final class ProductTests: XCTestCase {
    func test_GivenAProductExists_WhenStartWorkflowIsCalled_ThenClientRequestIsMade() async throws {
        let client = SpyAppStoreConnectAPIClient()
        let product = Product(name: "", id: "", repository: .init(id: "", name: ""), client: client)
        
        try await client.startWorkflow(with: "workflow-id", at: "git-ref-id")
        
        XCTAssertEqual(client.capturedStartWorkflowCalls[0].id, "workflow-id")
        XCTAssertEqual(client.capturedStartWorkflowCalls[0].gitReferenceId, "git-ref-id")
    }
}
