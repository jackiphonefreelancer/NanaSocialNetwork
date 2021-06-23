//
//  Date+Ex.swift
//  NanaSocialNetwork
//
//  Created by Teerapat on 6/21/21.
//

import Foundation

extension Date {
    func string(format: String = "yyyy-MM-dd'T'HH:mm:ssZ") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func timeAgoDisplay() -> String {
        let calendar = Calendar.current
        let minuteAgo = calendar.date(byAdding: .minute, value: -1, to: Date())!
        let hourAgo = calendar.date(byAdding: .hour, value: -1, to: Date())!
        let dayAgo = calendar.date(byAdding: .day, value: -1, to: Date())!
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: Date())!
        
        if minuteAgo < self {
            let diff = Calendar.current.dateComponents([.second], from: self, to: Date()).second ?? 0
            return diff.isPlural() ? "\(diff) seconds ago" : "just now"
        } else if hourAgo < self {
            let diff = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute ?? 0
            return diff.isPlural() ? "\(diff) minutes ago" : "\(diff) minute ago"
        } else if dayAgo < self {
            let diff = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour ?? 0
            return diff.isPlural() ? "\(diff) hours ago" : "\(diff) hour ago"
        } else if weekAgo < self {
            let diff = Calendar.current.dateComponents([.day], from: self, to: Date()).day ?? 0
            return diff.isPlural() ? "\(diff) days ago" : "\(diff) day ago"
        } else {
            let timeString = string(format: "HH:mm")
            let dateString = string(format: "MMMM dd yyyy")
            return String(format: "%@, %@", dateString, timeString)
        }
    }
}

extension Int {
    func isPlural() -> Bool {
        return self > 1
    }
}

extension TimeInterval {
    static let minute = 60.0
    static let hour = 60.0*60
    static let day = 60.0*60*24
}
