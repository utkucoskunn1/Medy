//
//  DateFormatterExtensions.swift
//  Medy
//
//  Created by Utku on 03/08/24.
//

import Foundation

extension DateFormatter {
    static var short: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
}
