@testable import XcodeCloudKit
import AppStoreConnect_Swift_SDK
import XCTest

class SpyAppStoreConnectAPIClient: AppStoreConnectAPIClient {
    var productsResponseToReturn: CiProductsResponse?
    func allProducts() async throws -> CiProductsResponse {
        try XCTUnwrap(productsResponseToReturn)
    }
    
    var productResponseToReturn: CiProductResponse?
    func product(id: String) async throws -> CiProductResponse {
        try XCTUnwrap(productResponseToReturn)
    }
    
    var capturedStartWorkflowCalls = [(id: String, gitReferenceId: String)]()
    func startWorkflow(with id: String, at gitReferenceId: String) async throws {
        capturedStartWorkflowCalls.append((id, gitReferenceId))
    }
    
    var workflowsResponseToReturn: WorkflowsResponse?
    func allWorkflows(for productId: String) async throws -> WorkflowsResponse {
        try XCTUnwrap(workflowsResponseToReturn)
    }
}
