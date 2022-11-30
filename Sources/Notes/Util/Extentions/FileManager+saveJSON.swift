import Foundation

extension FileManager {
	static func saveJSON(_ json: String) {
		let documentDirectory = FileManager.default.homeDirectoryForCurrentUser
		let pathWithFilename = documentDirectory.appendingPathComponent("noteData.json")
		do {
			try json.write(to: pathWithFilename, atomically: true, encoding: .utf8)
		} catch {
			print(error)
		}
	}
}
