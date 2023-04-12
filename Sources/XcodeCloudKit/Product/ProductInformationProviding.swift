public protocol ProductInformationProviding {
    func startWorkflow(with id: String, at gitReferenceId: String) async throws
    func workflows() async throws -> [Workflow]
    func createWorkflow() async throws
}
