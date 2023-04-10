public protocol ProductInformationProviding {
    func startWorkflow(with id: String, at gitReferenceId: String) async throws
}
