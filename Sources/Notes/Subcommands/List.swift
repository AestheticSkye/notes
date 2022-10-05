import Foundation
import ArgumentParser

extension Notes {
	struct List: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "Lists all notes. By default sorted by date.")
		
		@Flag(name: .long)
		var sortByName: Bool = false
		
		@Flag(name: .short, help: "Shows more information about the note")
		var verbose: Bool = false

		func run() {
			let persistence = Persistence()
			
			if persistence.noteData.count == 0 {
				print("No notes have been created yet. Use 'notes new <name>' to create one.")
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
				if verbose {
					var printedLines = Int()
					for (index, line) in note.text.enumerated() {
						if line != "" {
							print("\(index + 1): \(note.text[index])")
							printedLines += 1
						}
						if printedLines == 3 {
							break
						}
					}
					print("")
				}
			}
			
		}
	}
}
