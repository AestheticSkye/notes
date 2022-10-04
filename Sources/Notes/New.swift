import ArgumentParser
import Foundation
//import SwiftCursesTerm

#if os(macOS)
import Darwin.ncurses
#else
import Glibc.ncurses
#endif

extension Notes {
	struct New: ParsableCommand {
		func validate() throws {}
		
		func run() {
			let editor = Editor()
			
			print(editor.lines)
		}
	}
}
