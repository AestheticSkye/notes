import Foundation

extension Notes {
	struct Note: Codable {
		
		var title: String
		var text: [String]
		var date: String
	
		func contains(_ text: String) -> Bool {
			for line in self.text {
				if line.lowercased().contains(text) {
					return true
				}
			}
			return false
		}
		
		init(title: String, text: [String], date: String) {
			self.title = title
			self.text = text
			self.date = date
		}
	}
}
