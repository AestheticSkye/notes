import Foundation
import ArgumentParser

extension Notes {
	struct List: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "Lists all notes. By default sorted by date")
		
		@Flag(name: .long)
		var sortByName: Bool = false

		func run() {
			let persistence = Persistence()
			
			if persistence.noteData.count == 0 {
				print("No notes have been created yet. Use 'notes new' to create one.")
				Notes.List.exit()
			}
			
			var notes: [Note]
			
			if sortByName {
				notes = persistence.noteData.sorted(by: {
					$0.title.localizedCaseInsensitiveCompare($1.title) == ComparisonResult.orderedAscending })
			} else {
				notes = persistence.noteData
			}
			
			for note in notes {
				print(note.date.formatDate() + " " + note.title)
			}
			
		}
	}
}
