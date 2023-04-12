public struct Product {
    let name: String
    let id: String
    let repository: Repository
    
    let client: AuthenticatedTransport
    
    struct Repository {
        let id: String
        let name: String
    }
}
