import AppStoreConnect_Swift_SDK
@testable import XcodeCloudKit

class MockWorkflowsResponseBuilder {
    private var name: String = "random-name"
    private var id: String = "mock-workflows-response"
    
    func with(name: String) -> MockWorkflowsResponseBuilder {
        self.name = name
        return self
    }
    
    func with(id: String) -> MockWorkflowsResponseBuilder {
        self.id = id
        return self
    }
    
    func build() -> WorkflowsResponse {
        return WorkflowsResponse(data: [.init(id: id, attributes: .init(name: name))])
    }
}
