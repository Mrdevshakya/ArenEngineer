import Foundation
import Testing
@testable import Aren

@Suite(.serialized)
struct ArenConfigFileTests {
    @Test
    func configPathRespectsEnvOverride() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("aren-config-\(UUID().uuidString)")
            .appendingPathComponent("aren.json")
            .path

        await TestIsolation.withEnvValues(["AREN_CONFIG_PATH": override]) {
            #expect(ArenConfigFile.url().path == override)
        }
    }

    @MainActor
    @Test
    func remoteGatewayPortParsesAndMatchesHost() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("aren-config-\(UUID().uuidString)")
            .appendingPathComponent("aren.json")
            .path

        await TestIsolation.withEnvValues(["AREN_CONFIG_PATH": override]) {
            ArenConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "ws://gateway.ts.net:19999",
                    ],
                ],
            ])
            #expect(ArenConfigFile.remoteGatewayPort() == 19999)
            #expect(ArenConfigFile.remoteGatewayPort(matchingHost: "gateway.ts.net") == 19999)
            #expect(ArenConfigFile.remoteGatewayPort(matchingHost: "gateway") == 19999)
            #expect(ArenConfigFile.remoteGatewayPort(matchingHost: "other.ts.net") == nil)
        }
    }

    @MainActor
    @Test
    func setRemoteGatewayUrlPreservesScheme() async {
        let override = FileManager().temporaryDirectory
            .appendingPathComponent("aren-config-\(UUID().uuidString)")
            .appendingPathComponent("aren.json")
            .path

        await TestIsolation.withEnvValues(["AREN_CONFIG_PATH": override]) {
            ArenConfigFile.saveDict([
                "gateway": [
                    "remote": [
                        "url": "wss://old-host:111",
                    ],
                ],
            ])
            ArenConfigFile.setRemoteGatewayUrl(host: "new-host", port: 2222)
            let root = ArenConfigFile.loadDict()
            let url = ((root["gateway"] as? [String: Any])?["remote"] as? [String: Any])?["url"] as? String
            #expect(url == "wss://new-host:2222")
        }
    }

    @Test
    func stateDirOverrideSetsConfigPath() async {
        let dir = FileManager().temporaryDirectory
            .appendingPathComponent("aren-state-\(UUID().uuidString)", isDirectory: true)
            .path

        await TestIsolation.withEnvValues([
            "AREN_CONFIG_PATH": nil,
            "AREN_STATE_DIR": dir,
        ]) {
            #expect(ArenConfigFile.stateDirURL().path == dir)
            #expect(ArenConfigFile.url().path == "\(dir)/aren.json")
        }
    }
}
