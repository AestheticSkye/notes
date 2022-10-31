import ArgumentParser

extension Notes {
	struct Delete: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "Delete a note.")
		
		@Flag(name: .shortAndLong)
		var all = false
		
		@Argument(help: "Name of the note to delete.")
		var name: String?
		
		func validate() throws {
			if !all && name == nil {
				throw ValidationError("Please enter a name.")
			}
		}
		
		func run() throws {
			if all {
				print("Are you sure you want to delete all notes? [y/N]")
				let choice = readLine()
				if choice?.lowercased() == "y" {
					Persistence.deleteAll()
				}
			} else {
				var persistence = Persistence()
				persistence.delete(name!)
			}
		}
	}
}
