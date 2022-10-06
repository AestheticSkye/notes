import Foundation

extension Notes {
	struct Note: Codable {
		
		var title: String
		var text: [String]
		var date: String
		
		init(title: String, text: [String], date: String) {
			self.title = title
			self.text = text
			self.date = date
		}
	}
}
