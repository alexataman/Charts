//
//  File.swift
//  
//
//  Created by Oleksand Atamanskyi on 23.12.2019.
//

import Foundation
#if canImport(UIKit)
    import UIKit
#endif

@objc
public protocol IAxisValueExtendedFormatter: IAxisValueFormatter {
    func isFirstValue(_ value: Double) -> Bool
    func isLastValue(_ value: Double) -> Bool
    func markerStringForValue(_ value: Double) -> String
}

public class XYMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueExtendedFormatter
    private var data: [Double] = []
    fileprivate var yFormatter = NumberFormatter()

    public init(color: UIColor, firstFont: UIFont, secondFont: UIFont, firstTextColor: UIColor, secondTextColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueExtendedFormatter, data: [Double]) {
        self.xAxisValueFormatter = xAxisValueFormatter
        self.data = data
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 2
        super.init(color: color, firstFont: firstFont, secondFont: secondFont, firstTextColor: firstTextColor, secondTextColor: secondTextColor, insets: insets)
    }

    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let x = xAxisValueFormatter.markerStringForValue(entry.x)
        let string = "\(x)"
        isFirstValue = xAxisValueFormatter.isFirstValue(data.first ?? 0.0)
        isLastValue = xAxisValueFormatter.isLastValue(data.last ?? 0.0)
        setDateLabel(string)
        setHourLabel(entry.y.hoursMinutes())
    }

}
