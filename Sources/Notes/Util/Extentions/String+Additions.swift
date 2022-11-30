import Foundation

extension String {
	func formatDate() -> String {
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
		let date = dateFormatter.date(from: self)!
		dateFormatter.dateFormat = "YY/MM/dd HH:mm:ss"
		return dateFormatter.string(from: date)
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
