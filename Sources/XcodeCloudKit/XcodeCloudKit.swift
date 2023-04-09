public protocol XcodeCloudKit {
    func allProducts() async throws -> [Product]
}

public struct DefaultXcodeCloudKit: XcodeCloudKit {
    private let client: AppStoreConnectAPIClient
    
    init(client: AppStoreConnectAPIClient) {
        self.client = client
    }
    
    public func allProducts() async throws -> [Product] {
        let productResponse = try await client.allProducts()
        
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
                return Product(name: name, id: product.id, repository: .init(id: repository.id, name: repository.name))
            } else {
                return nil
            }
        }
    }
}
