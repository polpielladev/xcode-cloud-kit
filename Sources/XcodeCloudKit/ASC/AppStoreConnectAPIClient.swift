import AppStoreConnect_Swift_SDK

protocol AppStoreConnectAPIClient {
    func allProducts() async throws -> CiProductsResponse
    func product(id: String) async throws -> CiProductResponse
    func startWorkflow(with id: String, at gitReferenceId: String) async throws
    func allWorkflows(for productId: String) async throws -> WorkflowsResponse
}
