import ArgumentParser

//let persistence = Persistence()

@main
struct Notes: ParsableCommand {
    static let configuration = CommandConfiguration(
            abstract: "Note Utility.",
            subcommands: [List.self, New.self])

    func run() throws {
        New().run()
    }
}