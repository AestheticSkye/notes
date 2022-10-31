@testable import notes
import XCTest

final class NotesTests: XCTestCase {
	private func pressKey(_ keyCode: Int) async {
		let keyDown = CGEvent(keyboardEventSource: nil,
							  virtualKey: CGKeyCode(keyCode),
							  keyDown: true)
		
		let keyUp = CGEvent(keyboardEventSource: nil,
							virtualKey: CGKeyCode(keyCode),
							keyDown: false)
		
		keyDown?.post(tap: CGEventTapLocation.cghidEventTap)
		keyUp?.post(tap: CGEventTapLocation.cghidEventTap)
	}
	
	func testNew() throws {
		let process = Process()
		
		let projectDirectory = FileManager().currentDirectoryPath

		process.executableURL = URL(fileURLWithPath: "/usr/bin/swift")
		process.currentDirectoryURL = URL(fileURLWithPath: projectDirectory)
		process.arguments = ["run", "notes", "new"]
		
		try process.run()
		
//		sleep(10)
//
//		process.terminate()
		
		//		Task {
		//			sleep(1)
		//			await pressKey(6)
		//			sleep(1)
		//			await pressKey(0x35)
		//		}
		
		//		Notes.New().run()
		//		Notes.Editor()
	}
}
