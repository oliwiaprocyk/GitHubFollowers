//
//  Date+Ext.swift
//  GitHubFollowers
//
//  Created by Oliwia Procyk on 20/04/2023.
//

import Foundation

extension Date {
    
    func convertToMonthYearFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM yyyy"
        return dateFormatter.string(from: self)
    }
}
