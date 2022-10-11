import Foundation

extension Notes {
	struct Persistence {
		
		private enum Error: Swift.Error {
			case jsonDecodingError
		}
		
		var noteData = [Note]()
		
		// Counts through the current "Untitled" documents sequentially to get the next one
		mutating func getUntitledName(_ name: String?) -> String {
			do {
				try noteData = fetchPersistentData()
			} catch {
				print("Error getting note data")
			}
			
			if let name {
				return name
			}
			
			if query("Untitled") != nil {
				var currentUntitled = 2
				while true {
					if query("Untitled" + String(currentUntitled)) == nil {
						return "Untitled" + String(currentUntitled)
					}
					currentUntitled += 1
				}
			}
			
			return "Untitled"
			
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
