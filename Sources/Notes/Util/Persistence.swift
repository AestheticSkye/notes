import Foundation

extension Notes {
	struct Persistence {
		
		private enum Error: Swift.Error {
			case jsonEncodingError
		}
		
		var noteData = [Note]()
		
		// Checks to see if there is already a note with a title and returns the title with an integer appended if true
		mutating func checkDuplicate(_ title: String?) -> String {
			
			fetchPersistentData()
			
			let title = title ?? "Untitled"
			
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
				throw Error.jsonEncodingError
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
		
		private mutating func fetchPersistentData() {
			
			let documentDirectory: URL = FileManager.default.homeDirectoryForCurrentUser
			
			let pathWithFilename = documentDirectory.appendingPathComponent("noteData.json")
			
			do {

				if !FileManager().fileExists(atPath: pathWithFilename.path) {
					print("First time ran, initailizing noteData.json")
					try save()
				}
				
				let data = try Data(contentsOf: pathWithFilename, options: [])
				
				noteData = try JSONDecoder().decode([Note].self, from: data)
				
			} catch {
				print("Error fetching data: \(error)\n\nData file may be corrupted, you can check the file at '~/noteData' or reset the file with 'notes delete --all'")
				
				exit()
			}
			
		}
		
		static func deleteAll() {
			let documentDirectory = FileManager.default.homeDirectoryForCurrentUser
			let pathWithFilename = documentDirectory.appendingPathComponent("noteData.json")
			do {
				try "[]".write(to: pathWithFilename,
									 atomically: true,
									 encoding: .utf8)
			} catch {
				print(error)
			}
		}
		
		init() {
			fetchPersistentData()
		}
		
	}
}
