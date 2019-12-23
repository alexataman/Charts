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

public protocol IAxisValueExtendedFormatter: IAxisValueFormatter {
    func isFirstValue(_ value: String) -> Bool
    func isLastValue(_ value: String) -> Bool
}

public class XYMarkerView: BalloonMarker {
    public var xAxisValueFormatter: IAxisValueExtendedFormatter
    fileprivate var yFormatter = NumberFormatter()

    public init(color: UIColor, firstFont: UIFont, secondFont: UIFont, firstTextColor: UIColor, secondTextColor: UIColor, insets: UIEdgeInsets,
                xAxisValueFormatter: IAxisValueExtendedFormatter) {
        self.xAxisValueFormatter = xAxisValueFormatter
        yFormatter.minimumFractionDigits = 1
        yFormatter.maximumFractionDigits = 2
        super.init(color: color, firstFont: firstFont, secondFont: secondFont, firstTextColor: firstTextColor, secondTextColor: secondTextColor, insets: insets)
    }

    public override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        let x = xAxisValueFormatter.stringForValue(entry.x, axis: XAxis())
        let string = "\(x)"
        isFirstValue = xAxisValueFormatter.isFirstValue(x)
        isLastValue = xAxisValueFormatter.isLastValue(x)
        setDateLabel(string)
        setHourLabel(entry.y.hoursMinutes())
    }

}
