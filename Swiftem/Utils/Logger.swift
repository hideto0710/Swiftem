
import Foundation

class Logger {
    
    class func debug(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { Logger.write("[DEBUG]", message: message, function: function, file: file, line: line) }
    
    class func info(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { Logger.write("[INFO]", message: message, function: function, file: file, line: line) }
    
    class func warning(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { Logger.write("[WARNING]", message: message, function: function, file: file, line: line) }
    
    class func error(
        message: String,
        function: String = __FUNCTION__,
        file: String = __FILE__,
        line: Int = __LINE__) { Logger.write("[ERROR]", message: message, function: function, file: file, line: line) }
    
    class func write(
        loglevel: String,
        message: String,
        function: String,
        file: String,
        line: Int) {
            
            let now = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
            dateFormatter.timeStyle = .MediumStyle
            dateFormatter.dateStyle = .MediumStyle
            
            let nowdate = dateFormatter.stringFromDate(now)
            
            var filename = file
            if let match = filename.rangeOfString("[^/]*$", options: .RegularExpressionSearch) {
                filename = filename.substringWithRange(match)
            }
            print("\(loglevel)\"\(message)\" \(nowdate) L\(line) \(function) @\(filename)")
    }
}