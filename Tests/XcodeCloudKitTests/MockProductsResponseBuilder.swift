import AppStoreConnect_Swift_SDK

class MockProductsResponseBuilder {
    private var repository: (id: String, name: String)?
    private var name: String?
    private var id: String = "mock-products-response"
    
    func with(repositoryName: String, repositoryId: String) -> MockProductsResponseBuilder {
        repository = (repositoryId, repositoryName)
        return self
    }
    
    func with(name: String) -> MockProductsResponseBuilder {
        self.name = name
        return self
    }
    
    func with(id: String) -> MockProductsResponseBuilder {
        self.id = id
        return self
    }
    
    func build() -> CiProductsResponse {
        var includedItems = [CiProductsResponse.IncludedItem]()
        
        if let repository {
            let scmRepository = ScmRepository(
                type: .scmRepositories,
                id: repository.id,
                attributes: .init(repositoryName: repository.name),
                links: .init(this: "")
            )
            includedItems.append(.scmRepository(scmRepository))
        }
        
        return CiProductsResponse(data: [
            .init(
                type: .ciProducts,
                id: id,
                attributes: name == nil ? nil : .init(name: name!),
                relationships: repository == nil ? nil : .init(primaryRepositories: .init(data: [.init(type: .scmRepositories, id: repository!.id)])),
                links: .init(this: "")
            )
        ], included: includedItems, links: .init(this: ""))
    }
}
