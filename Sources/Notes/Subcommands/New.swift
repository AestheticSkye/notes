import ArgumentParser
import Foundation

extension Notes {
	struct New: ParsableCommand {
		static var configuration = CommandConfiguration(abstract: "Create a new note.")
		
		@Argument(help: "The name for the note. If left blank the name will be \"Untitled\".")
		var name: String?
		
		func run() {
			
			var persistence = Persistence()
			
			if let name {
				if persistence.checkForDuplicate(name) == true {
					print("Name \"\(name)\" already taken")
					return
				}
			}
			
			let text = Editor().lines
			
			persistence.create(title: persistence.getUntitledName(name), text: text, date: Date())
		}
	}
}
