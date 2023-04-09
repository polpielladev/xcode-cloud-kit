struct CiProduct {
    let id: String
    let repository: Repository
    let name: String
    
    struct Repository {
        let name: String
        let id: String
    }
}
