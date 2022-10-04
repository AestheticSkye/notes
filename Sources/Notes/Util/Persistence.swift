import Foundation

enum JSONError: Error {
	case jsonEncodingError, jsonFetchError, cannotFindJson, jsonDecodingError
}

final class Persistence {
	
	var noteData: [Note]?
	
	func fetchItem() {}
	
	func fetchAll() {}
	
	func create() {}
	
	func save() throws {
		guard let jsonString = String(data: try JSONEncoder().encode(noteData),
									  encoding: String.Encoding.utf8)
		else {
			throw JSONError.jsonEncodingError
		}

		if let documentDirectory = FileManager.default.urls(for: .desktopDirectory,
															in: .userDomainMask).first {
			let pathWithFilename = documentDirectory.appendingPathComponent("noteData.json")
			do {
				try jsonString.write(to: pathWithFilename,
									 atomically: true,
									 encoding: .utf8)
			} catch {
				print(error)
			}
		}
	}
	
	func delete() {}

	private func fetchPersistentData() throws -> [Note] {
		
		guard let documentsUrl: URL = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask).first

		else {
			throw JSONError.jsonFetchError
		}

		let destinationFileUrl = documentsUrl.appendingPathComponent("noteData.json")

		var decodedData = [Note]()
		
		do {
			
			let data = try Data(contentsOf: destinationFileUrl, options: [])
			
			decodedData = try JSONDecoder().decode([Note].self, from: data)
			
		} catch {
			throw error
		}
		
		return decodedData

	}

	init() {
		do {
			noteData = try fetchPersistentData()
		} catch {
//			print(error)
		}
	}

}

