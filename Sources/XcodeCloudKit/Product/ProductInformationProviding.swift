public protocol ProductInformationProviding {
    func startWorkflow(with id: String, at gitReferenceId: String) async throws
    func workflows() async throws -> [Workflow]
    func workflow(with id: String) async throws -> Workflow
    func workflow(with name: String) async throws -> Workflow?
}
