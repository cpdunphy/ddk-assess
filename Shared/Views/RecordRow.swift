//
//  RecordRow.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 10/1/20.
//

import SwiftUI

struct RecordRow : View {
    var record : Record
    var body : some View {
        VStack(alignment: .leading) {
            HStack {
                Text("\(record.taps) \(record.taps == 1 ? "tap" : "taps")")
                Spacer()
                Text(record.timed ? getSecondsLength(time: Int(record.duration)) : getSecondsLengthDouble(time: record.duration))
            }
            HStack {
                HStack {
                    Text(dateDescription(date: record.date))
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    Text("[\(dateToString(date: record.date))]")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
                Spacer()
                Text("\(record.timed ? "Timer" : "Count")")
                    .font(.footnote)
                    .foregroundColor(Color(#colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)))
            }
        }
    }
    func getSecondsLength(time: Int) -> String {
        if time / 60 >= 1 {
            return "\(time / 60) \(time / 60 == 1 ? "minute" : "minutes")"
        } else {
            return "\(time) \(time == 1 ? "second" : "seconds")"
        }
    }
    
    func getSecondsLengthDouble(time: Double) -> String {
        if time / 60 >= 1 {
            return "\(time / 60) \(time / 60 == 1 ? "minute" : "minutes")"
        } else {
            let send = String(format: "%.1f", time)
            return "\(send) \(send == "1.0" ? "second" : "seconds")"
        }
    }
    
    func dateDescription(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yy 'at' HH:mm"
        return formatter.string(from: date)
    }
    
    
    func dateToString(date : Date) -> String {
        print("Calculating")
        let interval = Date().timeIntervalSince(date)
        var str = 0
        var unit : TimeUnits = .seconds
        
        if interval / 60.0 / 60.0 / 60.0 > 1 {
            str = Int(interval / 60.0 / 60.0 / 60.0)
            unit = .days
        } else if interval / 60.0 / 60.0 > 1 {
            str = Int(interval / 60.0 / 60.0)
            unit = .hours
        } else if interval / 60.0 > 1 {
            str = Int(interval / 60.0)
            unit = .minutes
        } else {
            str = Int(interval)
        }
        
        return "\(str) \(str == 1 ? "\(unit.rawValue) ago" : "\(unit.rawValue)s ago")"
    }
}
