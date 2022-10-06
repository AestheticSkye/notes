import ArgumentParser

extension Notes {
	struct Edit: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "Edit a note.")
		
		@Argument(help: "Name of the note to edit.")
		var name: String
		
		func run() {
			var persistence = Persistence()
			guard var note = persistence.query(name) else {
				print("Could not find note \"\(name)\"")
				return
			}
			let editor = Editor(note.text)
			
			note.text = editor.lines
			
			persistence.edit(note)
		}
	}
}

