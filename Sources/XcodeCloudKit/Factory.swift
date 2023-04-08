import Foundation

public enum Factory {
    public static func make() -> XcodeCloudKit {
        return DefaultXcodeCloudKit()
    }
}
