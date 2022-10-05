import Foundation

extension String {
	func formatDate() -> String {
		let dateFormattor = DateFormatter()
		dateFormattor.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
		let date = dateFormattor.date(from: self)!
		dateFormattor.dateFormat = "YY/MM/dd HH:mm:ss"
		return dateFormattor.string(from: date)
	}
}
