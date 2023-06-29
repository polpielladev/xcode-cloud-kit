import AppStoreConnect_Swift_SDK

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
    
    static func workflow(with id: String) -> TransportRequest<CiWorkflowResponse> {
        let workflow = APIEndpoint
            .v1
            .ciWorkflows
            .id(id)
            .get()
        
        return .init(path: workflow.path, method: workflow.method, queryParameters: workflow.query)
    }
    
    static func getMacosVersions() -> TransportRequest<CiMacOsVersionsResponse> {
        let endpoint = APIEndpoint
            .v1
            .ciMacOsVersions
            .get(parameters: .init(fieldsCiMacOsVersions: [.name, .version]))
        
        return .init(path: endpoint.path, method: endpoint.method, queryParameters: endpoint.query)
    }
    
    static func getXcodeVersions() -> TransportRequest<CiXcodeVersionsResponse> {
        let endpoint = APIEndpoint
            .v1
            .ciXcodeVersions
            .get(parameters: .init(fieldsCiXcodeVersions: [.version, .name, .macOsVersions]))
        
        return .init(path: endpoint.path, method: endpoint.method, queryParameters: endpoint.query)
    }
    
    static func allBuilds(for workflowId: String) -> TransportRequest<CiBuildRunsResponse> {
        let endpoint = APIEndpoint
            .v1
            .ciWorkflows
            .id(workflowId)
            .buildRuns
            .get()
        
        return .init(path: endpoint.path, method: endpoint.method, queryParameters: endpoint.query)
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
