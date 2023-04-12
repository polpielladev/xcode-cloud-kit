extension Product: ProductInformationProviding {
    public func startWorkflow(with id: String, at gitReferenceId: String) async throws {
        _ = try await client.perform(request: RequestBuilder.triggerWorkflow(id: id, gitReferenceId: gitReferenceId))
    }
    
    public func workflows() async throws -> [Workflow] {
        let allWorkflows = try await client.perform(request: RequestBuilder.allWorkflows(for: id))
        
        return allWorkflows.data.map { Workflow(id: $0.id, name: $0.attributes.name) }
    }
    
    public func workflow(with id: String) async throws -> Workflow {
        let workflow = try await client.perform(request: RequestBuilder.workflow(with: id))
        
        return Workflow(id: workflow.data.id, name: workflow.data.attributes?.name ?? "")
    }
}
