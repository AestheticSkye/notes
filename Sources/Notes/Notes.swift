import ArgumentParser

@main
struct Notes: ParsableCommand {
	static let configuration = CommandConfiguration(
		abstract: "Note Utility.",
		subcommands: [List.self,
					  New.self,
					  Edit.self,
					  Delete.self
					 ])
}
