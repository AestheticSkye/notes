import CWrapper

#if os(macOS)
// Backspace keycode on linux is different to macOS
// Will default to ncurses declaration on linux
let KEY_BACKSPACE: Int32 = 127
#endif

extension Notes {
	struct Editor {
		
		private mutating func run() {
			ESCDELAY = 0
			initscr()
			cbreak()
			noecho()
			keypad(stdscr, true)
			
			while mode != .exit {
				updateStatus()
				printBuffer()
				let input = getch()
				handleInput(input)
			}
			
			endwin()
		}
		
		init(_ contents: [String]) {
			lines = contents
			run()
		}
		
		init() {
			run()
		}
		
		private enum Mode {
			case normal, exit
		}
		
		private var x: Int = 0
		private var y: Int = 0
		
		private var mode = Mode.normal
		var lines = [String()]
		
		private mutating func moveUp() {
			if y-1 >= 0 {
				y -= 1
			}
			if x >= lines[y].count {
				x = lines[y].count
			}
			move(Int32(y), Int32(x))
		}
		private mutating func moveDown() {
			if y+1 < LINES-1 && y+1 < lines.count {
				y += 1
			}
			if x >= lines[y].count {
				x = lines[y].count
			}
			move(Int32(y), Int32(x))
		}
		private mutating func moveLeft() {
			if x-1 >= 0 {
				x -= 1
				move(Int32(y), Int32(x))
			}
		}
		private mutating func moveRight() {
			if x+1 < COLS && x+1 <= lines[y].count
			{
				x += 1
				move(Int32(y), Int32(x))
			}
		}
		
		mutating func handleInput(_ input: Int32) {
			switch input {
				case KEY_LEFT:
					moveLeft()
					return
				case KEY_RIGHT:
					moveRight()
					return
				case KEY_UP:
					moveUp()
					return
				case KEY_DOWN:
					moveDown()
					return
				case 27: // ESC Key
					mode = .exit
					break
				case KEY_BACKSPACE:
					if x == 0 && y > 0 {
						x = lines[y-1].count
						lines[y-1] += lines[y]
						lines.remove(at: y)
						clrtoeol()
						moveUp()
					} else if x == 0 && y == 0 {
					} else {
						lines[y].remove(at: x - 1)
						moveLeft()
						clrtoeol()
					}
					break
				case KEY_DC:
					if x == lines[y].count && y != lines.count - 1 {
						// Bring the line down
						lines[y] += lines[y+1];
						// Delete the line
						lines.remove(at: y + 1)
					} else {
						lines[y].remove(at: x)
					}
					break
					
				case 10: // Return/Enter
					if x < lines[y].count {
						let line = lines[y]
						let startIndex = line.index(line.startIndex, offsetBy: x)
						let range = startIndex..<line.endIndex
						// Put the rest of the line on a new line
						lines.insert(String(line[range]), at: y + 1)
						// Remove that part of the line
						lines[y].removeSubrange(range)
						clrtoeol()
						
					} else {
						lines.insert("", at: y+1)
					}
					x = 0
					moveDown()
					break
				case 9: // Tab
					for _ in 1...4 {
						lines[y].insert(Character(" "), at: x)
					}
					x += 4
				default:
					if let letter = input.convertToASCII() {
						lines[y].insert(letter, at: x)
						x += 1
					}
			}
		}
		func printBuffer() {
			for line in 0...LINES-2 {
				if line >= lines.count {
					move(line, 0)
					clrtoeol()
				}
				else
				{
					lines[Int(line)].withCString { body in
						movePrint(Int32(line), 0, body, false)
						clrtoeol()
					}
				}
			}
			move(Int32(y), Int32(x))
		}
		func updateStatus() {
			let status = "Press ESC to save\tCOL: \(x)\tROW: \(y)"
			status.withCString { body in
				movePrint(LINES-1, 0, body, true)
			}
			
			move(Int32(y),Int32(x))
		}
	}
}
