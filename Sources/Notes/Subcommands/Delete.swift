import ArgumentParser

extension Notes {
	struct Delete: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "Delete a note.")
		
		@Flag(name: .shortAndLong)
		var all: Bool = false
		
		@Argument(help: "Name of the note to delete.")
		var name: String?
		
		func validate() throws {
			if !all && name == nil {
				throw ValidationError("Please enter a name.")
			}
		}
		
		func run() throws {
			var persistence = Persistence()
			if all {
				print("Are you sure you want to delete all notes? [y/N]")
				let choice = readLine()
				if choice?.lowercased() == "y" {
					for note in persistence.noteData{
						persistence.delete(note.title)
					}
				}
			} else {
				persistence.delete(name!)
			}
		}
	}
}
