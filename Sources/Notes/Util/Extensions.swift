import Foundation

extension String {
	func formatDate() -> String {
		let dateFormattor = DateFormatter()
		dateFormattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
		let date = dateFormattor.date(from: self)!
		dateFormattor.dateFormat = "YY/MM/dd HH:mm:ss"
		return dateFormattor.string(from: date)
	}
	
	
	// These two functions exist the existing functions require String.Index to work
	mutating func insert(_ newElement: Character, at index: Int) {
		var array = Array(self)
		array.insert(newElement, at: index)
		self = String(array)
	}
	
	mutating func remove(at index: Int) {
		var array = Array(self)
		array.remove(at: index)
		self = String(array)
	}
}

extension FixedWidthInteger {
	// Some keys (function keys) send non UInt8 numbers causing crash
	func convertToASCII() -> Character? {
		if self <= 255 && self > 0 {
			return Character(UnicodeScalar(UInt8(self)))
		}
		return nil
	}
}

extension FileManager {
	static func saveJSON(_ json: String) {
		let documentDirectory = FileManager.default.homeDirectoryForCurrentUser
		let pathWithFilename = documentDirectory.appendingPathComponent("noteData.json")
		do {
			try json.write(to: pathWithFilename,
						   atomically: true,
						   encoding: .utf8)
		} catch {
			print(error)
		}
	}
}
