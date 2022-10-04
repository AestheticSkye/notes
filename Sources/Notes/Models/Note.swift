import Foundation

final class Note: Identifiable, Codable {
	var id = UUID()
	
	var title: String
	var text: [String]
	var date: String
	
	init(id: UUID = UUID(), title: String, text: [String], date: String) {
		self.id = id
		self.title = title
		self.text = text
		self.date = date
	}
}
