//
//  File.swift
//  
//
//  Created by Oleksand Atamanskyi on 23.12.2019.
//

import Foundation

extension Double {
    static func hoursMinutes(seconds: Double) -> Double {
        let (hours, daysMins) = modf(seconds / 3_600)
        return (hours + nearbyint(daysMins.toMinutes()) * 0.01).rounded(toPlaces: 2)
    }

    func toMinutes() -> Self {
        return self * 3_600.0 / 60.0
    }
    
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension Double {
    func hoursMinutes() -> String {
        let split = splitIntoParts(decimalPlaces: 3, round: true)
        return "\(split.leftPart)h \(split.rightPart)m"
    }

    func splitIntoParts(decimalPlaces: Int, round: Bool) -> (leftPart: Int, rightPart: Int) {

        var number = self
        if round {
            //round to specified number of decimal places:
            let divisor = pow(10.0, Double(decimalPlaces))
            number = Darwin.round(self * divisor) / divisor
        }

        //convert to string and split on decimal point:
        let parts = String(number).components(separatedBy: ".")

        //extract left and right parts:
        let leftPart = Int(parts[0]) ?? 0
        let rightPart = Int(parts[1]) ?? 0

        return(leftPart, rightPart)

    }
}
