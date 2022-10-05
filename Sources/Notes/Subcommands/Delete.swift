import ArgumentParser

extension Notes {
	struct Delete: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "Delete a note.")
		
		@Argument(help: "Name of the note to delete")
		var name: String
		
		func run() throws {
			let persistence = Persistence()
			
			persistence.delete(name)
		}
	}
}
