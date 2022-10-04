import ArgumentParser

extension Notes {
	struct List: ParsableCommand {
		static let configuration = CommandConfiguration(abstract: "Lists all notes.")

		func validate() throws {
//			if persistence.noteData == nil {
//				throw ValidationError("No notes have been created yet. Use 'notes new' to create one.")
//			}
		}

		func run() {

		}
	}
}