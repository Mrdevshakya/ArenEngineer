import Foundation

private struct RootCommand {
    var name: String
    var args: [String]
}

@main
struct ArenMacCLI {
    static func main() async {
        let args = Array(CommandLine.arguments.dropFirst())
        let command = parseRootCommand(args)
        switch command?.name {
        case nil:
            printUsage()
        case "-h", "--help", "help":
            printUsage()
        case "connect":
            await runConnect(command?.args ?? [])
        case "discover":
            await runDiscover(command?.args ?? [])
        case "wizard":
            await runWizardCommand(command?.args ?? [])
        default:
            fputs("aren-mac: unknown command\n", stderr)
            printUsage()
            exit(1)
        }
    }
}

private func parseRootCommand(_ args: [String]) -> RootCommand? {
    guard let first = args.first else { return nil }
    return RootCommand(name: first, args: Array(args.dropFirst()))
}

private func printUsage() {
    print("""
    aren-mac

    Usage:
      aren-mac connect [--url <ws://host:port>] [--token <token>] [--password <password>]
                           [--mode <local|remote>] [--timeout <ms>] [--probe] [--json]
                           [--client-id <id>] [--client-mode <mode>] [--display-name <name>]
                           [--role <role>] [--scopes <a,b,c>]
      aren-mac discover [--timeout <ms>] [--json] [--include-local]
      aren-mac wizard [--url <ws://host:port>] [--token <token>] [--password <password>]
                          [--mode <local|remote>] [--workspace <path>] [--json]

    Examples:
      aren-mac connect
      aren-mac connect --url ws://127.0.0.1:18789 --json
      aren-mac discover --timeout 3000 --json
      aren-mac wizard --mode local
    """)
}
