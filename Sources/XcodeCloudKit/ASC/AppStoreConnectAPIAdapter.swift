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
    
    func allWorkflows(for productId: String) async throws -> WorkflowsResponse {
        let allWorkflowsEndpoint = APIEndpoint
            .v1
            .ciProducts
            .id(productId)
            .workflows
        
        let workflows = try await appStoreConnectSDK
            .request(
                Request<WorkflowsResponse>(
                    method: "GET",
                    path: allWorkflowsEndpoint.path,
                    query: [("fields[ciWorkflows]", "name")]
                )
            )
        
        return workflows
    }
}

struct WorkflowsResponse: Decodable {
    let data: [Data]
    
    struct Data: Decodable {
        let id: String
        let attributes: Attributes
        
        struct Attributes: Decodable {
            let name: String
        }
    }
}

