import Foundation

public protocol WorkflowInformationProviding {
    func allBuilds() async throws -> [Build]
    func build(with number: Int) async throws -> Build?
}

extension Workflow: WorkflowInformationProviding {
    public func allBuilds() async throws -> [Build] {
        let allBuilds = try await client.perform(request: RequestBuilder.allBuilds(for: id))
        
        return allBuilds
            .data
            .map {
                Build(
                    number: $0.attributes?.number,
                    id: $0.id,
                    createdAt: $0.attributes?.createdDate,
                    endedAt: $0.attributes?.finishedDate,
                    startedAt: $0.attributes?.startedDate
                )
            }
    }
    
    public func build(with number: Int) async throws -> Build? {
        let allBuilds = try await client.perform(request: RequestBuilder.allBuilds(for: id))
            .data
            .map {
                Build(
                    number: $0.attributes?.number,
                    id: $0.id,
                    createdAt: $0.attributes?.createdDate,
                    endedAt: $0.attributes?.finishedDate,
                    startedAt: $0.attributes?.startedDate
                )
            }
        
        return allBuilds.first(where: { $0.number == number })
    }
}
