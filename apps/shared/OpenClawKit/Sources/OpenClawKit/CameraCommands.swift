import Foundation

public enum ArenCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum ArenCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum ArenCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum ArenCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct ArenCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: ArenCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: ArenCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: ArenCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: ArenCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct ArenCameraClipParams: Codable, Sendable, Equatable {
    public var facing: ArenCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: ArenCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: ArenCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: ArenCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
