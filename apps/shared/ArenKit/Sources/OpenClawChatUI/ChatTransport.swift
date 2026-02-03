import Foundation

public enum ArenChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(ArenChatEventPayload)
    case agent(ArenAgentEventPayload)
    case seqGap
}

public protocol ArenChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> ArenChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [ArenChatAttachmentPayload]) async throws -> ArenChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> ArenChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<ArenChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension ArenChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "ArenChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> ArenChatSessionsListResponse {
        throw NSError(
            domain: "ArenChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}
