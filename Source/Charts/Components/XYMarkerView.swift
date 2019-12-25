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
    func markerStringForValue(_ value: Double) -> String
}

public class XYMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueExtendedFormatter
    private var data: [String] = []
    fileprivate var yFormatter = NumberFormatter()

    public init(color: UIColor, firstFont: UIFont, secondFont: UIFont, firstTextColor: UIColor, secondTextColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueExtendedFormatter, data: [String]) {
        self.xAxisValueFormatter = xAxisValueFormatter
        self.data = data
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 2
        super.init(color: color, firstFont: firstFont, secondFont: secondFont, firstTextColor: firstTextColor, secondTextColor: secondTextColor, insets: insets)
    }

    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let x = xAxisValueFormatter.markerStringForValue(entry.x)
        isFirstValue = data.first == x
        isLastValue = data.last == x
        setDateLabel(x)
        setHourLabel(entry.y.hoursMinutes())
    }

}
