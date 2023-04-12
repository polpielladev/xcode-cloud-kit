import AppStoreConnect_Swift_SDK

struct TransportRequest<T: Decodable> {
    let path: String
    let method: String
    let queryParameters: [(key: String, value: String?)]?
}

protocol AuthenticatedTransport {
    func perform<T: Decodable>(request: TransportRequest<T>) async throws -> T
}

enum RequestBuilder {
    static func products() -> TransportRequest<CiProductsResponse> {
        let productsEndpoint = APIEndpoint
            .v1
            .ciProducts
            .get(parameters: .init(include: [.primaryRepositories]))
        
        return .init(path: productsEndpoint.path, method: productsEndpoint.method, queryParameters: productsEndpoint.query)
    }
    
    static func product(with id: String) -> TransportRequest<CiProductResponse> {
        let productEndpoint = APIEndpoint
            .v1
            .ciProducts
            .id(id)
            .get(parameters: .init(include: [.primaryRepositories]))
        
        return .init(path: productEndpoint.path, method: productEndpoint.method, queryParameters: productEndpoint.query)
    }
    
    static func triggerWorkflow(id: String, gitReferenceId: String) -> TransportRequest<CiBuildRunResponse> {
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
        
        return .init(path: workflowRun.path, method: workflowRun.method, queryParameters: workflowRun.query)
    }
    
    static func allWorkflows(for productId: String) -> TransportRequest<WorkflowsResponse> {
        let allWorkflowsEndpoint = APIEndpoint
            .v1
            .ciProducts
            .id(productId)
            .workflows
        
        return .init(path: "GET", method: allWorkflowsEndpoint.path, queryParameters: [("fields[ciWorkflows]", "name")])
    }
}

class AppStoreConnectSDKAdapter: AuthenticatedTransport {
    private let appStoreConnectSDK: APIProvider
    
    init(appStoreConnectSDK: APIProvider) {
        self.appStoreConnectSDK = appStoreConnectSDK
    }
    
    func perform<T>(request: TransportRequest<T>) async throws -> T where T : Decodable {
        return try await appStoreConnectSDK.request(Request<T>(method: request.method, path: request.path, query: request.queryParameters))
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

