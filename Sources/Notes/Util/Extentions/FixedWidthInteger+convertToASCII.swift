extension FixedWidthInteger {
	// Some keys (function keys) send non UInt8 numbers causing crash
	func convertToASCII() -> Character? {
		if self <= 127 && self > 0 {
			return Character(UnicodeScalar(UInt8(self)))
		}
		return nil
	}
}
