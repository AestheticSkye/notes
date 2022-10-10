import Foundation
import ArgumentParser

extension Notes {
	struct List: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "List all notes. Sorted by date by default.")
		
		@Flag(name: .long)
		var sortByName: Bool = false
		
		@Option(name: .long)
		var filterByName: String?
		
		@Option(name: .long)
		var filterByContents: String?
		
		@Flag(name: .shortAndLong, help: "Show more information about the note.")
		var verbose: Bool = false
		
		// Takes in persistence parameter to avoid having to reinitialize Persistence, saving performence
		private func sortAndFilter(_ persistence: Persistence) -> [Note] {
			var notes = persistence.noteData
			
			if sortByName {
				notes.sort(by: {
					$0.title.localizedCaseInsensitiveCompare($1.title) == ComparisonResult.orderedAscending })
			}
			
			if let filterByName {
				notes = notes.filter({ note in
					note.title
						.lowercased()
						.contains(filterByName)
				})
			}
			
			if let filterByContents {
				notes = notes.filter({ note in
					note.contains(filterByContents)
				})
			}
			
			return notes
		}

		func run() {
			let persistence = Persistence()
			
			if persistence.noteData.count == 0 {
				print("No notes have been created yet. Use 'notes new <name>' to create one.")
				Self.exit()
			}
			
			var notes = sortAndFilter(persistence)
			
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
