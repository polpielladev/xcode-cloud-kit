extension Product: ProductInformationProviding {
    public func startWorkflow(with id: String, at gitReferenceId: String) async throws {
        try await client.startWorkflow(with: id, at: gitReferenceId)
    }
    
    public func workflows() async throws -> [Workflow] {
        let allWorkflows = try await client.allWorkflows(for: id)
        
        return allWorkflows.data.map { Workflow(id: $0.id, name: $0.attributes.name) }
    }
}
