import ArgumentParser
import Foundation

extension Notes {
	struct New: ParsableCommand {
		static var configuration = CommandConfiguration(abstract: "Create a new note.")
		
		@Argument(help: "The name for the note. If left blank the name will be \"Untitled\".")
		var name: String?
		
		func run() {
			
			var persistence = Persistence()
			
			let text = Editor().lines
			
			persistence.create(title: persistence.checkDuplicate(name), text: text, date: Date())
		}
	}
}
