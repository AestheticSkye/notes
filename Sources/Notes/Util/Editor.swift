import CWrapper

final class Editor {
	
	private func run() {
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
	
	private func moveUp() {
		if y-1 >= 0 {
			y -= 1;
		}
		if x >= lines[y].count {
			x = lines[y].count
		}
		move(Int32(y), Int32(x));
	}
	private func moveDown() {
		if y+1 < LINES-1 && y+1 < lines.count {
			y += 1;
		}
		if x >= lines[y].count {
			x = lines[y].count;
		}
		move(Int32(y), Int32(x));
	}
	private func moveLeft() {
		if x-1 >= 0 {
			x -= 1
			move(Int32(y), Int32(x))
		}
	}
	private func moveRight() {
		if x+1 < COLS && x+1 <= lines[y].count
		{
			x += 1;
			move(Int32(y), Int32(x));
		}
	}
	
	func handleInput(_ input: Int32) {
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
			default:
				break
		}
		
		switch mode {
			case .normal:
				switch input {
					case 27: // ESC Key
						mode = .exit
						break
					case 127: // Backspace
						if x == 0 && y > 0 {
							x = lines[y-1].count
							lines[y-1] += lines[y]
							lines.remove(at: Int(y))
							clrtoeol()
							moveUp()
						} else if x == 0 && y == 0 {
						} else {
							var line = Array(lines[Int(y)])
							line.remove(at: Int(x) - 1)
							lines[Int(y)] = String(line)
							moveLeft()
							clrtoeol()
						}
						break
					case KEY_DC: break
						// MARK: Implement later
						
					case 10: // Return/Enter
							 // The Enter key
							 // Bring the rest of the line down
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
						x = 0;
						moveDown();
						break;
					case 9: // Tab
						var line: [Character] = Array(lines[Int(y)])
						for _ in 1...4 {
							line.insert(Character(" "), at: Int(x))
						}
						lines[Int(y)] = String(line)
						x += 4
					default:
						var line: [Character] = Array(lines[Int(y)])
						line.insert(Character(UnicodeScalar(UInt8(input))), at: Int(x))
						lines[Int(y)] = String(line)
						x += 1
				}
			case .exit: break
				
		}
	}
	func printBuffer() {
		for i in 0...LINES-1 {
			if i >= lines.count {
				move(i, 0);
			}
			else
			{
				lines[Int(i)].withCString { body in
					movePrint(i, 0, body, false)
				}
			}
		}
		move(Int32(y), Int32(x));
	}
	func updateStatus() {
		let status = "Press ESC to save\tCOL: \(x)\tROW: \(y)"
		status.withCString { body in
			movePrint(LINES-1, 0, body, true)
		}
		
		move(Int32(y),Int32(x))
	}
}

