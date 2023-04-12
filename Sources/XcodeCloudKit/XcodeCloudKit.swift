public protocol XcodeCloudKit {
    func allProducts() async throws -> [Product]
    func product(withName: String) async throws -> Product?
    func product(fromRepository repository: String) async throws -> Product?
    func product(withId id: String) async throws -> Product?
}

public struct DefaultXcodeCloudKit: XcodeCloudKit {
    private let client: AuthenticatedTransport
    
    init(client: AuthenticatedTransport) {
        self.client = client
    }
    
    public func product(withName name: String) async throws -> Product? {
        let allProducts = try await allProducts()
        
        return allProducts.first(where: { $0.name == name })
    }
    
    public func product(fromRepository repository: String) async throws -> Product? {
        let allProducts = try await allProducts()
        
        return allProducts.first(where: { $0.repository.name == repository })
    }
    
    public func product(withId id: String) async throws -> Product? {
        let productResponse = try await client.perform(request: RequestBuilder.product(with: id))
        
        let repositories: [(id: String, name: String)] = productResponse.included?.compactMap { includedItem in
            switch includedItem {
            case .scmRepository(let scmData):
                if let name = scmData.attributes?.repositoryName {
                    return (scmData.id, name)
                } else {
                    return nil
                }
            default: return nil
            }
        } ?? []
        
        let product = productResponse.data
        
        if let repository = repositories.first(where: { product.relationships?.primaryRepositories?.data?.first?.id == $0.id }),
           let name = product.attributes?.name {
            return Product(name: name, id: product.id, repository: .init(id: repository.id, name: repository.name), client: client)
        } else {
            return nil
        }        
    }
    
    public func allProducts() async throws -> [Product] {
        let productResponse = try await client.perform(request: RequestBuilder.products())
        
        let repositories: [(id: String, name: String)] = productResponse.included?.compactMap { includedItem in
            switch includedItem {
            case .scmRepository(let scmData):
                if let name = scmData.attributes?.repositoryName {
                    return (scmData.id, name)
                } else {
                    return nil
                }
            default: return nil
            }
        } ?? []
        
        return productResponse.data.compactMap { product in
            if let repository = repositories.first(where: { product.relationships?.primaryRepositories?.data?.first?.id == $0.id }),
               let name = product.attributes?.name {
                return Product(name: name, id: product.id, repository: .init(id: repository.id, name: repository.name), client: client)
            } else {
                return nil
            }
        }
    }
}
