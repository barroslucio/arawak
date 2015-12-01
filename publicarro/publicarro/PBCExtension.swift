
import UIKit
import Foundation

extension String
{
    
    static func convertFromNSDateToString(date:NSDate) -> String
    {
        let dateFormatter = NSDateFormatter()
        
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.stringFromDate(date)
    }
    
}

