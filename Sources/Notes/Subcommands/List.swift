import ArgumentParser

extension Notes {
	struct List: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "Lists all notes.")
		
//		@Flag(name: .long) var sortByDate: Bool?
//		@Flag(name: .long) var sortByName: Bool?

		func run() {
			let persistence = Persistence()
			
			if persistence.noteData.count == 0 {
				print("No notes have been created yet. Use 'notes new' to create one.")
				Notes.List.exit()
			}
			
			for note in persistence.noteData {
				print(note.date.formatDate() + " " + note.title)
			}
			
		}
	}
}
