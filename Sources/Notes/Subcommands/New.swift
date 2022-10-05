import ArgumentParser
import Foundation

extension Notes {
	struct New: ParsableCommand {
		func validate() throws {}
		
		@Argument(help: "The name for the note. If left blank the name will be the first line")
		var name: String = "Untitled"
		
		func run() {
			let editor = Editor()
			let persistence = Persistence()
			persistence.create(title: name, text: editor.lines, date: Date())
		}
	}
}
