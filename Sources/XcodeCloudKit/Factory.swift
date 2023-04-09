import AppStoreConnect_Swift_SDK

public enum Factory {
    public static func make(issuerID: String, privateKeyID: String, privateKey: String) throws -> XcodeCloudKit {
        let configuration = try APIConfiguration(issuerID: issuerID, privateKeyID: privateKeyID, privateKey: privateKey)
        let provider = APIProvider(configuration: configuration)
        let client = AppStoreConnectSDKAdapter(appStoreConnectSDK: provider)
        
        return DefaultXcodeCloudKit(client: client)
    }
}
