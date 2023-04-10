import AppStoreConnect_Swift_SDK

class AppStoreConnectSDKAdapter: AppStoreConnectAPIClient {
    private let appStoreConnectSDK: APIProvider
    
    init(appStoreConnectSDK: APIProvider) {
        self.appStoreConnectSDK = appStoreConnectSDK
    }
    
    func allProducts() async throws -> CiProductsResponse {
        let productsEndpoint = APIEndpoint
            .v1
            .ciProducts
            .get(parameters: .init(include: [.primaryRepositories]))
    
        
        return try await appStoreConnectSDK.request(productsEndpoint)
    }
    
    func product(id: String) async throws -> CiProductResponse {
        let productEndpoint = APIEndpoint
            .v1
            .ciProducts
            .id(id)
            .get(parameters: .init(include: [.primaryRepositories]))
        
        return try await appStoreConnectSDK.request(productEndpoint)
    }
    
    func startWorkflow(with id: String, at gitReferenceId: String) async throws {
        let requestRelationships = CiBuildRunCreateRequest
            .Data
            .Relationships(
                workflow: .init(data: .init(type: .ciWorkflows, id: id)),
                sourceBranchOrTag: .init(data: .init(type: .scmGitReferences, id: gitReferenceId))
            )
        
         let requestData = CiBuildRunCreateRequest.Data(
             type: .ciBuildRuns,
             relationships: requestRelationships
         )

        let buildRunCreateRequest = CiBuildRunCreateRequest(data: requestData)

        let workflowRun = APIEndpoint
            .v1
            .ciBuildRuns
            .post(buildRunCreateRequest)
        
        _ = try await appStoreConnectSDK.request(workflowRun)
    }
}
