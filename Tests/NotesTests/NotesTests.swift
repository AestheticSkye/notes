import XCTest
@testable import notes

final class notesTests: XCTestCase {
	
//	private func pressKey(_ keyCode: Int) async {
//		let keyDown = CGEvent(keyboardEventSource: nil,
//							  virtualKey: CGKeyCode(keyCode),
//							  keyDown: true)
//
//		let keyUp = CGEvent(keyboardEventSource: nil,
//							virtualKey: CGKeyCode(keyCode),
//							keyDown: false)
//
//		keyDown?.post(tap: CGEventTapLocation.cghidEventTap)
//		keyUp?.post(tap: CGEventTapLocation.cghidEventTap)
//	}
	
	func testNew() throws {
		let process = Process()
		
		var executable = FileManager().currentDirectoryPath
		executable.append(contentsOf: "/.build/debug/notes")

		process.executableURL = URL(fileURLWithPath: executable)
		process.arguments = ["new"]
		
		try process.run()
		
		sleep(10)
		
		process.terminate()
		
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
