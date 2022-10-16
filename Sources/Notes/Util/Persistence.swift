import Foundation

extension Notes {
	struct Persistence {
		
		private enum Error: Swift.Error {
			case jsonDecodingError
		}
		
		var noteData = [Note]()
		
		// Checks to see if there is already a note with a title and returns the title with an integer appended if true
		mutating func checkDuplicate(_ title: String?) -> String {
			
			let title = title ?? "Untitled"
			
			do {
				try noteData = fetchPersistentData()
			} catch {
				print("Error getting note data")
			}
			
			if query(title) != nil {
				var currentUntitled = 2
				while true {
					if query(title + String(currentUntitled)) == nil {
						return title + String(currentUntitled)
					}
					currentUntitled += 1
				}
			}
			
			return title
			
		}
		
		func query(_ title: String) -> Note? {
			for note in noteData {
				if note.title == title {
					return note
				}
			}
			return nil
		}
		
		mutating func edit(_ note: Note) {
			for (index, oldNote) in noteData.enumerated() {
				if oldNote.title == note.title {
					noteData[index] = note
					do {
						try save()
					} catch {
						print("Failed to save note")
					}
					return
				}
			}
		}
		
		mutating func create(title: String, text: [String], date: Date) {
			let newNote = Note(title: title, text: text, date: date.description)
			noteData.append(newNote)
			do {
				try save()
				print("Note saved as \"\(title)\"")
			} catch {
				print("Failed to save note")
			}
		}
		
		mutating func delete(_ title: String) {
			for (index, note) in noteData.enumerated() {
				if note.title == title {
					noteData.remove(at: index)
					do {
						try save()
					} catch {
						print("Failed to save note")
					}
					return
				}
			}
			print("Could not find \"\(title)\"")
		}
		
		private func save() throws {
			guard let jsonString = String(data: try JSONEncoder().encode(noteData),
										  encoding: String.Encoding.utf8)
			else {
				throw Error.jsonDecodingError
			}
			
			let documentDirectory = FileManager.default.homeDirectoryForCurrentUser
			let pathWithFilename = documentDirectory.appendingPathComponent("noteData.json")
			do {
				try jsonString.write(to: pathWithFilename,
									 atomically: true,
									 encoding: .utf8)
			} catch {
				print(error)
			}
			
		}
		
		private func fetchPersistentData() throws -> [Note] {
			
			let documentDirectory: URL = FileManager.default.homeDirectoryForCurrentUser
			
			let pathWithFilename = documentDirectory.appendingPathComponent("noteData.json")
			
			var decodedData = [Note]()
			
			do {
				
				let data = try Data(contentsOf: pathWithFilename, options: [])
				
				decodedData = try JSONDecoder().decode([Note].self, from: data)
				
			} catch {
				try save()
				return try fetchPersistentData()
			}
			
			return decodedData
			
		}
		
		init() {
			do {
				noteData = try fetchPersistentData()
			} catch {
				print("Error: \(error)")
			}
		}
		
	}
}
