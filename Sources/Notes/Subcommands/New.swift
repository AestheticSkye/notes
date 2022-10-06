import ArgumentParser
import Foundation

extension Notes {
	struct New: ParsableCommand {
		static var configuration = CommandConfiguration(abstract: "Create a new note.")
		
		@Argument(help: "The name for the note. If left blank the name will be \"Untitled\".")
		var name: String?
		
		func run() {
			
			var persistence = Persistence()
			
			let newName: String = {
				if let name {
					return name
				}
				if persistence.checkForDuplicate("Untitled") == true {
					var currentUntitled = 2
					while true {
						if persistence.checkForDuplicate("Untitled" + String(currentUntitled)) != true {
							return "Untitled" + String(currentUntitled)
						}
						currentUntitled += 1
					}
				}
				return "Untitled"
				
			}()
			if persistence.checkForDuplicate(newName) == true {
				print("Name \"\(newName)\" already taken")
				return
			}
			persistence.create(title: newName, text: Editor().lines, date: Date())
		}
	}
}
