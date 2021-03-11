//
//  String+Extension.swift
//  SwiftNewDemo
//
//  Created by Qing Class on 2019/12/12.
//  Copyright © 2019 Albert. All rights reserved.
//

#if canImport(Foundation)
import Foundation
#endif

#if canImport(CoreGraphics)
import CoreGraphics
#endif

#if canImport(UIKit)
import UIKit
#endif

extension String {
    func hexStringToInt() -> UInt64 {
        var result: UInt64 = 0
        for char in self.uppercased().utf8 {
            if char >= 48 && char < 58 {
                result = result * 16 + UInt64(char) - 48
            } else if (char >= 65 && char <= 70) {
                result = result * 16 + UInt64(char) - 55
            } else {
                return 0
            }
        }
        return result
    }
    
    func hexStringToIntSystem() -> UInt64 {
        //通过字符串创建一个16进制的数，失败则返回nil
        return UInt64(self, radix: 16) ?? 0
    }
}

// MARK: - Base64
public extension String {

    #if canImport(Foundation)
    /// String decoded from base64 (if applicable).
    ///
    ///     "SGVsbG8gV29ybGQh".base64Decoded() = Optional("Hello World!")
    ///
    func base64Decoded() -> String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        guard let decodedData = Data(base64Encoded: self) else { return nil }
        return String(data: decodedData, encoding: .utf8)
    }
    #endif
    
    #if canImport(Foundation)
    /// String encoded in base64 (if applicable).
    ///
    ///     "Hello World!".base64Encoded() -> Optional("SGVsbG8gV29ybGQh")
    ///
    func base64Encoded() -> String? {
        // https://github.com/Reza-Rg/Base64-Swift-Extension/blob/master/Base64.swift
        let plainData = data(using: .utf8)
        return plainData?.base64EncodedString()
    }
    #endif
    
}

// MARK: - Json
public extension String {
    
    #if canImport(Foundation)
    
    /// 把Foundation对象json化成一个字符串
    ///
    ///     String(fromJson: [1, 2]) == "[1,2]"
    ///
    /// - Parameter jsonObject: Foundation对象
    ///   For possible values, see `JSONSerialization.ReadingOptions`.
    init?(fromJson object: Any, options: JSONSerialization.WritingOptions = []) {
        guard JSONSerialization.isValidJSONObject(object) else { return nil }
        let data = try? JSONSerialization.data(withJSONObject: object, options: options)
        guard let anData = data else { return nil }
        self.init(bytes: anData, encoding: .utf8)
    }
    #endif

    #if canImport(Foundation)
    /// 把当前字符串解析成Foundation对象
    ///
    ///     "[1,2]".asJsonObject() as? Array == [1, 2]
    ///
    /// - Parameter options: Options for reading the JSON data and creating the Foundation object.
    ///
    ///   For possible values, see `JSONSerialization.ReadingOptions`.
    /// - Returns: A Foundation object from the JSON data in the receiver, or `nil` if an error occurs.
    /// - Throws: An `NSError` if the receiver does not represent a valid JSON object.
    func asJsonObject(options: JSONSerialization.ReadingOptions = []) -> Any? {
        guard let stringData = data(using: .utf8) else { return nil }
        return try? JSONSerialization.jsonObject(with: stringData, options: options)
    }
    #endif
    
}

// MARK: - Valid
public extension String {

    /// Check if string contains one or more emojis.
    ///
    ///     "Hello 😀".containEmoji -> true
    ///
    var containEmoji: Bool {
        // http://stackoverflow.com/questions/30757193/find-out-if-character-in-string-is-emoji
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F, // Emoticons
            0x1F300...0x1F5FF, // Misc Symbols and Pictographs
            0x1F680...0x1F6FF, // Transport and Map
            0x1F1E6...0x1F1FF, // Regional country flags
            0x2600...0x26FF, // Misc symbols
            0x2700...0x27BF, // Dingbats
            0xE0020...0xE007F, // Tags
            0xFE00...0xFE0F, // Variation Selectors
            0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
            127000...127600, // Various asian characters
            65024...65039, // Variation selector
            9100...9300, // Misc items
            8400...8447: // Combining Diacritical Marks for Symbols
                return true
            default:
                continue
            }
        }
        return false
    }
    
    /// Check if string contains only letters.
    ///
    ///     "abc".isAlphabetic -> true
    ///     "123abc".isAlphabetic -> false
    ///
    var isAlphabetic: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        return hasLetters && !hasNumbers
    }
    
    /// Check if string contains at least one letter and one number.
    ///
    ///     "123abc".isAlphaNumeric -> true
    ///     "abc".isAlphaNumeric -> false
    ///
    var isAlphaNumeric: Bool {
        let hasLetters = rangeOfCharacter(from: .letters, options: .numeric, range: nil) != nil
        let hasNumbers = rangeOfCharacter(from: .decimalDigits, options: .literal, range: nil) != nil
        let comps = components(separatedBy: .alphanumerics)
        return comps.joined(separator: "").count == 0 && hasLetters && hasNumbers
    }
    
    /// Check if string is palindrome.
    ///
    ///     "abcdcba".isPalindrome -> true
    ///     "Mom".isPalindrome -> true
    ///     "A man a plan a canal, Panama!".isPalindrome -> true
    ///     "Mama".isPalindrome -> false
    ///
    var isPalindrome: Bool {
        let letters = filter { $0.isLetter }
        guard !letters.isEmpty else { return false }
        let midIndex = letters.index(letters.startIndex, offsetBy: letters.count / 2)
        let firstHalf = letters[letters.startIndex..<midIndex]
        let secondHalf = letters[midIndex..<letters.endIndex].reversed()
        return !zip(firstHalf, secondHalf).contains(where: { $0.lowercased() != $1.lowercased() })
    }
    
    #if canImport(Foundation)
    /// Check if string is valid email format.
    ///
    /// - Note: Note that this property does not validate the email address against an email server. It merely attempts to determine whether its format is suitable for an email address.
    ///
    ///     "john@doe.com".isValidEmail -> true
    ///
    var isValidEmail: Bool {
        // http://emailregex.com/
        let regex = "^(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])$"
        return range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
    #endif
    
    #if canImport(Foundation)
    /// Check if string is a valid URL.
    ///
    ///     "https://google.com".isValidUrl -> true
    ///
    var isValidUrl: Bool {
        return URL(string: self) != nil
    }
    #endif
    
    #if canImport(Foundation)
    /// Check if string is a valid schemed URL.
    ///
    ///     "https://google.com".isValidSchemedUrl -> true
    ///     "google.com".isValidSchemedUrl -> false
    ///
    var isValidSchemedUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme != nil
    }
    #endif
    
    #if canImport(Foundation)
    /// Check if string is a valid https URL.
    ///
    ///     "https://google.com".isValidHttpsUrl -> true
    ///
    var isValidHttpsUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "https"
    }
    #endif
    
    #if canImport(Foundation)
    /// Check if string is a valid http URL.
    ///
    ///     "http://google.com".isValidHttpUrl -> true
    ///
    var isValidHttpUrl: Bool {
        guard let url = URL(string: self) else { return false }
        return url.scheme == "http"
    }
    #endif
    
    #if canImport(Foundation)
    /// Check if string is a valid file URL.
    ///
    ///     "file://Documents/file.txt".isValidFileUrl -> true
    ///
    var isValidFileUrl: Bool {
        return URL(string: self)?.isFileURL ?? false
    }
    #endif
    
    #if canImport(Foundation)
    /// Check if string is a valid Swift number. Note: In North America, "." is the decimal separator, while in many parts of Europe "," is used,
    ///
    ///     "123".isNumeric -> true
    ///     "1.3".isNumeric -> true (en_US)
    ///     "1,3".isNumeric -> true (fr_FR)
    ///     "abc".isNumeric -> false
    ///
    var isNumeric: Bool {
        let scanner = Scanner(string: self)
        scanner.locale = NSLocale.current
        #if os(Linux)
        return scanner.scanDecimal() != nil && scanner.isAtEnd
        #else
        return scanner.scanDecimal(nil) && scanner.isAtEnd
        #endif
    }
    #endif
    
    #if canImport(Foundation)
    /// Check if string only contains digits.
    ///
    ///     "123".isDigits -> true
    ///     "1.3".isDigits -> false
    ///     "abc".isDigits -> false
    ///
    var isDigits: Bool {
        return CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: self))
    }
    #endif

    #if canImport(Foundation)
    /// Check if the given string contains only white spaces
    ///
    ///     "".isWhitespace -> true
    ///     "\n\n ".isWhitespace -> true
    ///     "abc".isWhitespace -> false
    ///
    var isWhitespace: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    #endif
    
}

// MARK: - URL encode & decode
public extension String {

    #if canImport(Foundation)
    /// Readable string from a URL string.
    ///
    ///     "it's%20easy%20to%20decode%20strings".urlDecoded() -> "it's easy to decode strings"
    ///
    func urlDecoded() -> String {
        return removingPercentEncoding ?? self
    }
    #endif
    
    #if canImport(Foundation)
    /// URL escaped string.
    ///
    ///     "it's easy to encode strings".urlEncoded() -> "it's%20easy%20to%20encode%20strings"
    ///
    func urlEncoded() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
    #endif

    #if canImport(Foundation)
    /// Readable string from a URL string.
    ///
    ///     "it's%20easy%20to%20decode%20strings".urlQueryDecoded() -> "it's easy to decode strings"
    ///
    func urlQueryDecoded() -> String {
        return removingPercentEncoding ?? self
    }
    #endif
    
    #if canImport(Foundation)
    /// URL escaped string.
    ///
    ///     "it's easy to encode strings".urlQuerEncoded() -> "it's%20easy%20to%20encode%20strings"
    ///
    func urlQueryEncoded() -> String {
        return addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    }
    #endif

}

// MARK: - Numbric convert
public extension String {
    
    #if canImport(Foundation)
    /// Float value from string (if applicable).
    ///
    /// - Returns: Optional Int value from given string.
    func asInt() -> Int? {
        return Int(self)
    }
    #endif
    
    #if canImport(Foundation)
    /// Float value from string (if applicable).
    ///
    /// - Returns: Optional Float value from given string.
    func asFloat() -> Float? {
        return Float(self)
    }
    #endif
    
    #if canImport(Foundation)
    /// Double value from string (if applicable).
    ///
    /// - Returns: Optional Double value from given string.
    func asDouble() -> Double? {
        return Double(self)
    }
    #endif
    
    #if canImport(CoreGraphics) && canImport(Foundation)
    /// CGFloat value from string (if applicable).
    ///
    /// - Returns: Optional CGFloat value from given string.
    func asCGFloat() -> CGFloat? {
        guard let double = Double(self) else { return nil }
        return CGFloat(double)
    }
    #endif
}

// MARK: - Properties
public extension String {
    
    /// Array of characters of a string.
    ///
    ///     "1.3".charactersArray -> ["1", ".", "3"]
    ///
    var charactersArray: [Character] {
        return Array(self)
    }
    
}

// MARK: - Methods
public extension String {
    
    /// First character of string (if applicable).
    ///
    ///     "Hello".firstCharacterAsString -> Optional("H")
    ///     "".firstCharacterAsString -> nil
    ///
    func firstCharacterAsString() -> String? {
        guard let first = first else { return nil }
        return String(first)
    }
    
    #if canImport(Foundation)
    /// Array of strings separated by new lines.
    ///
    ///     "Hello\ntest".lines() -> ["Hello", "test"]
    ///
    /// - Returns: Strings separated by new lines.
    func lines() -> [String] {
        var result = [String]()
        enumerateLines { line, _ in
            result.append(line)
        }
        return result
    }
    #endif
    
    #if canImport(Foundation)
    /// Returns a localized string, with an optional comment for translators.
    ///
    ///     "Hello world".localized -> Hallo Welt
    ///
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    #endif
    
    /// Array with unicodes for all characters in a string.
    ///
    ///     "SwifterSwift".unicodeArray() -> [83, 119, 105, 102, 116, 101, 114, 83, 119, 105, 102, 116]
    ///
    /// - Returns: The unicodes for all characters in a string.
    func unicodeArray() -> [Int] {
        return unicodeScalars.map { Int($0.value) }
    }
    
    #if canImport(Foundation)
    /// an array of all words in a string
    ///
    ///     "Swift is amazing".words() -> ["Swift", "is", "amazing"]
    ///
    /// - Returns: The words contained in a string.
    func words() -> [String] {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        return comps.filter { !$0.isEmpty }
    }
    #endif
    
    #if canImport(Foundation)
    /// Count of words in a string.
    ///
    ///     "Swift is amazing".wordsCount() -> 3
    ///
    /// - Returns: The count of words contained in a string.
    func wordCount() -> Int {
        // https://stackoverflow.com/questions/42822838
        let chararacterSet = CharacterSet.whitespacesAndNewlines.union(.punctuationCharacters)
        let comps = components(separatedBy: chararacterSet)
        let words = comps.filter { !$0.isEmpty }
        return words.count
    }
    #endif
    
    #if canImport(Foundation)
    /// Check if string contains one or more instance of substring.
    ///
    ///     "Hello World!".contain("O") -> false
    ///     "Hello World!".contain("o", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string contains one or more instance of substring.
    func contains(_ string: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return range(of: string, options: .caseInsensitive) != nil
        }
        return range(of: string) != nil
    }
    #endif
    
    #if canImport(Foundation)
    /// Count of substring in string.
    ///
    ///     "Hello World!".count(of: "o") -> 2
    ///     "Hello World!".count(of: "L", caseSensitive: false) -> 3
    ///
    /// - Parameters:
    ///   - string: substring to search for.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: count of appearance of substring in string.
    func count(of string: String, caseSensitive: Bool = true) -> Int {
        if !caseSensitive {
            return lowercased().components(separatedBy: string.lowercased()).count - 1
        }
        return components(separatedBy: string).count - 1
    }
    #endif
    
    /// Check if string ends with substring.
    ///
    ///     "Hello World!".ends(with: "!") -> true
    ///     "Hello World!".ends(with: "WoRld!", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string ends with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string ends with substring.
    func ends(with suffix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasSuffix(suffix.lowercased())
        }
        return hasSuffix(suffix)
    }
    
    /// Check if string starts with substring.
    ///
    ///     "hello World".starts(with: "h") -> true
    ///     "hello World".starts(with: "H", caseSensitive: false) -> true
    ///
    /// - Parameters:
    ///   - suffix: substring to search if string starts with.
    ///   - caseSensitive: set true for case sensitive search (default is true).
    /// - Returns: true if string starts with substring.
    func starts(with prefix: String, caseSensitive: Bool = true) -> Bool {
        if !caseSensitive {
            return lowercased().hasPrefix(prefix.lowercased())
        }
        return hasPrefix(prefix)
    }
    
    /// Reverse string.
    ///
    ///     var s = "Hello World!"
    ///     s.reverse()
    ///     print(s) -> "!dlroW olleH"
    ///
    @discardableResult
    mutating func reverse() -> String {
        let chars: [Character] = reversed()
        self = String(chars)
        return self
    }
    
    /// Reverse string.
    ///
    ///
    ///
    /// - Returns: Reversed string
    func reversingString() -> String {
        let chars: [Character] = reversed()
        return String(chars)
    }
    
    #if canImport(Foundation)
    /// Removes spaces and new lines in beginning and end of string.
    ///
    ///     var str = "  \n Hello World \n\n\n"
    ///     str.trim()
    ///     print(str) // prints "Hello World"
    ///
    @discardableResult
    mutating func trim() -> String {
        self = trimmingCharacters(in: .whitespacesAndNewlines)
        return self
    }
    #endif
    
    #if canImport(Foundation)
    /// String with no spaces or new lines in beginning and end.
    ///
    ///     "   hello  \n".trimmed() -> "hello"
    ///
    func trimmed() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    #endif
    
    #if canImport(Foundation)
    /// Verify if string matches the regex pattern.
    ///
    /// - Parameter pattern: Pattern to verify.
    /// - Returns: true if string matches the pattern.
    func matches(pattern: String) -> Bool {
        return range(of: pattern, options: .regularExpression, range: nil, locale: nil) != nil
    }
    #endif
    
    /// Removes given prefix from the string.
    ///
    ///     "Hello, World!".removingPrefix("Hello, ") -> "World!"
    ///
    /// - Parameter prefix: Prefix to remove from the string.
    /// - Returns: The string after prefix removing.
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
    
    /// Removes given suffix from the string.
    ///
    ///     "Hello, World!".removingSuffix(", World!") -> "Hello"
    ///
    /// - Parameter suffix: Suffix to remove from the string.
    /// - Returns: The string after suffix removing.
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }
    
    /// Adds prefix to the string.
    ///
    ///     "www.apple.com".withPrefix("https://") -> "https://www.apple.com"
    ///
    /// - Parameter prefix: Prefix to add to the string.
    /// - Returns: The string with the prefix prepended.
    func withPrefix(_ prefix: String) -> String {
        // https://www.hackingwithswift.com/articles/141/8-useful-swift-extensions
        guard !hasPrefix(prefix) else { return self }
        return prefix + self
    }
}

// MARK: - Subscript
public extension String {
    
    /// Safely subscript string with index.
    ///
    ///     "Hello World!"[safe: 3] -> "l"
    ///     "Hello World!"[safe: 20] -> nil
    ///
    /// - Parameter index: index.
    subscript(safe index: Int) -> Character? {
        guard index >= 0 && index < count else { return nil }
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    /// Safely subscript string within a half-open range.
    ///
    ///     "Hello World!"[safe: 6..<11] -> "World"
    ///     "Hello World!"[safe: 6..<100] -> "World!"
    ///     "Hello World!"[safe: 21..<110] -> nil
    ///
    /// - Parameter range: Half-open range.
    subscript(safe range: Range<Int>) -> String {
        guard let lowerIndex = index(startIndex, offsetBy: max(0, range.lowerBound), limitedBy: endIndex) else { return "" }
        guard let upperIndex = index(lowerIndex, offsetBy: min(range.upperBound, self.count) - range.lowerBound, limitedBy: endIndex) else { return "" }
        return String(self[lowerIndex..<upperIndex])
    }
    
    /// Safely subscript string within a closed range.
    ///
    ///     "Hello World!"[safe: 6...11] -> "World!"
    ///     "Hello World!"[safe: 6...100] -> "World!"
    ///     "Hello World!"[safe: 21...110] -> nil
    ///
    /// - Parameter range: Closed range.
    subscript(safe range: ClosedRange<Int>) -> String {
        let lowerBound = max(0, range.lowerBound)
        guard let lowerIndex = index(startIndex, offsetBy: lowerBound, limitedBy: endIndex) else { return "" }
        guard let upperIndex = index(lowerIndex, offsetBy: min(range.upperBound, self.count - 1) - lowerBound, limitedBy: endIndex) else { return "" }
        return String(self[lowerIndex...upperIndex])
    }
    
    /// Safely subscript string within a partial Range through.
    ///
    ///     "Hello World!"[safe: ...11] -> "Hello World"
    ///     "Hello World!"[safe: ...-1] -> "Hello World"
    ///     "Hello World!"[safe: ...100] -> "Hello World"
    ///
    /// - Parameter range: partial Range through
    subscript(safe range: PartialRangeThrough<Int>) -> String? {
        guard range.upperBound >= 0 else { return "" }
        return self[safe: 0...range.upperBound]
    }
    
    /// Safely subscript string within a partial Range from.
    ///
    ///     "Hello World!"[safe: 6..] -> "Hello World"
    ///     "Hello World!"[safe: 12...] -> "Hello World"
    ///     "Hello World!"[safe: -100...] -> "Hello World"
    ///
    /// - Parameter range: partial Range from
    subscript(safe range: PartialRangeFrom<Int>) -> String? {
        guard range.lowerBound <= count - 1 else { return "" }
        return self[safe: range.lowerBound...(count - 1)]
    }
    
    /// Safely subscript string within a partial Range up to.
    ///
    ///     "Hello World!"[safe: ..<11] -> "Hello World"
    ///     "Hello World!"[safe: ..<-1] -> "Hello World"
    ///     "Hello World!"[safe: ..<100] -> "Hello World"
    ///
    /// - Parameter range: partial Range up to
    subscript(safe range: PartialRangeUpTo<Int>) -> String? {
        guard range.upperBound > 0 else { return "" }
        return self[safe: 0..<range.upperBound]
    }
    
}

// MARK: - Compare
public extension String {

    /// Compare with another version string.
    ///
    ///     compareVersion("1.1.1", "1.1.0") => .orderedDescending
    ///     compareVersion("1.1", "1.1.1") => .orderedAscending
    ///     compareVersion("1.0", "1.0.0") => .orderedSame
    ///     compareVersion("1.011.1", "1.11.1") => .orderedSame
    ///     compareVersion("3.11.1", "3.11.b") => .orderedAscending
    ///     compareVersion("3.11.1", "3.11.1b") => .orderedAscending
    ///     compareVersion("3.11.1", "3.2b.1") => .orderedDescending
    ///
    /// - Returns: compare result
    func compareVersion(_ version: String) -> ComparisonResult {
        let components1 = self.split(separator: ".")
        let components2 = version.split(separator: ".")
        
        let length = max(components1.count, components2.count)
        for index in 0..<length {
            let subVersion1 = (components1.count > index) ? components1[index] : "0"
            let subVersion2 = (components2.count > index) ? components2[index] : "0"
            
            let result = subVersion1.compare(subVersion2, options: .numeric)
            if (result != .orderedSame) {
                return result
            }
        }
        return .orderedSame
    }

}

// MARK: - Operators
public extension String {
    
    /// Repeat string multiple times.
    ///
    ///     'bar' * 3 -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: string to repeat.
    ///   - rhs: number of times to repeat character.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: String, rhs: Int) -> String {
        guard rhs > 0 else { return "" }
        return String(repeating: lhs, count: rhs)
    }
    
    /// Repeat string multiple times.
    ///
    ///     3 * 'bar' -> "barbarbar"
    ///
    /// - Parameters:
    ///   - lhs: number of times to repeat character.
    ///   - rhs: string to repeat.
    /// - Returns: new string with given string repeated n times.
    static func * (lhs: Int, rhs: String) -> String {
        guard lhs > 0 else { return "" }
        return String(repeating: rhs, count: lhs)
    }
    
}

#if canImport(UIKit)

public extension String {
    
    /// 计算文本占用大小
    /// - Parameters:
    ///   - font: 文本字体
    ///   - constainedSize: 限制大小
    func boundingRect(with font: UIFont, constainedSize: CGSize) -> CGRect {
        let rect = self.boundingRect(with: constainedSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return rect
    }
    
    /// 计算文本高度
    /// - Parameters:
    ///   - attributes: 文本属性
    ///   - constrainedWidth: 限制宽度
    func height(with attributes: [NSAttributedString.Key: Any], constrainedWidth: CGFloat) -> CGFloat {
        guard count > 0 && constrainedWidth > 0 else { return 0 }
        
        let size = CGSize(width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.height
    }
    
    /// 计算文本高度
    /// - Parameters:
    ///   - font: 文本字体
    ///   - constrainedWidth: 限制宽度
    func height(with font: UIFont, constrainedWidth : CGFloat) -> CGFloat {
        guard count > 0 && constrainedWidth > 0 else { return 0 }
        
        let size = CGSize(width: constrainedWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return rect.size.height
    }
    
    /// 计算文本宽度
    /// - Parameter attributes: 文本属性
    func width(with attributes: [NSAttributedString.Key: Any]) -> CGFloat {
        guard count > 0 else { return 0 }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let rect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.width
    }
    
    /// 计算文本宽度
    /// - Parameter font: 文本字体
    func width(with font: UIFont) -> CGFloat {
        guard count > 0 else { return 0 }
        
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 0)
        let rect = self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        return rect.size.width
    }
    
}

#endif

extension String {
    private func isMobileNumber(mobileNum: String) -> Bool {
        /**
         * 手机号码
         * 移动：134/135/136/137/138/139/150/151/152/157/158/159/182/183/184/187/188/147/178
         * 联通：130/131/132/155/156/185/186/145/176
         * 电信：133/153/180/181/189/177
         */
        let mobile = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
        let CM = "^1(34[0-8]|(3[5-9]|5[0127-9]|8[23478]|47|78)\\d)\\d{7}$"
        let CU = "^1(3[0-2]|5[256]|8[56]|45|76)\\d{8}$"
        let CT = "^1((33|53|77|8[019])[0-9]|349)\\d{7}$"
        let predicateMobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        let predicateCM = NSPredicate(format: "SELF MATCHES %@", CM)
        let predicateCU = NSPredicate(format: "SELF MATCHES %@", CU)
        let predicateCT = NSPredicate(format: "SELF MATCHES %@", CT)
        if predicateMobile.evaluate(with: mobileNum) ||
           predicateCM.evaluate(with: mobileNum) ||
           predicateCU.evaluate(with: mobileNum) ||
           predicateCT.evaluate(with: mobileNum) {
            return true
        } else {
            return false
        }
        
    }

}

