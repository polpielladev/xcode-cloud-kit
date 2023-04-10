extension Product: ProductInformationProviding {
    public func startWorkflow(with id: String, at gitReferenceId: String) async throws {
        try await client.startWorkflow(with: id, at: gitReferenceId)
    }
}
