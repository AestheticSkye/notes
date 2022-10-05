import ArgumentParser
import Foundation

extension Notes {
	struct New: ParsableCommand {
		func validate() throws {}
		
		@Argument(help: "The name for the note. If left blank the name will be the first line")
		var name: String?
		
		func run() {
			
			let persistence = Persistence()
			
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
			let editor = Editor()
			persistence.create(title: newName, text: editor.lines, date: Date())
		}
	}
}
