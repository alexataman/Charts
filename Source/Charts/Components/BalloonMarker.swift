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

open class BalloonMarker: MarkerImage
{
    open var color: UIColor
    open var arrowSize = CGSize(width: 11, height: 5)
    open var firstFont: UIFont
    open var secondFont: UIFont
    open var firstTextColor: UIColor
    open var secondTextColor: UIColor
    open var insets: UIEdgeInsets
    open var minimumSize = CGSize()
    open var isFirstValue: Bool = false
    open var isLastValue: Bool = false
    open var cornerValueOffset: CGFloat = 25

    fileprivate var dateLabel: String?
    fileprivate var hourLabel: String?
    fileprivate var _labelSize: CGSize = CGSize()
    fileprivate var _paragraphStyle: NSMutableParagraphStyle?
    fileprivate var _dateLabelDrawAttributes = [NSAttributedString.Key: Any]()
    fileprivate var _hourLabelDrawAttributes = [NSAttributedString.Key: Any]()

    public init(color: UIColor, firstFont: UIFont, secondFont: UIFont, firstTextColor: UIColor, secondTextColor: UIColor, insets: UIEdgeInsets) {
        self.color = color
        self.firstFont = firstFont
        self.secondFont = secondFont
        self.firstTextColor = firstTextColor
        self.secondTextColor = secondTextColor
        self.insets = insets

        _paragraphStyle = NSParagraphStyle.default.mutableCopy() as? NSMutableParagraphStyle
        _paragraphStyle?.alignment = .center
        super.init()
    }

    open override func offsetForDrawing(atPoint point: CGPoint) -> CGPoint {
        var offset = self.offset
        var size = self.size

        if size.width == 0.0 && image != nil {
            size.width = image!.size.width
        }
        if size.height == 0.0 && image != nil {
            size.height = image!.size.height
        }

        let width = size.width
        let height = size.height
        let padding: CGFloat = 8.0

        var origin = point
        origin.x -= width / 2
        origin.y -= height

        if origin.x + offset.x < 0.0 {
            offset.x = -origin.x + padding
        } else if let chart = chartView,
            origin.x + width + offset.x > chart.bounds.size.width {
            offset.x = chart.bounds.size.width - origin.x - width - padding
        }

        if origin.y + offset.y < 0 {
            offset.y = height + padding
        } else if let chart = chartView,
            origin.y + height + offset.y > chart.bounds.size.height {
            offset.y = chart.bounds.size.height - origin.y - height - padding
        }

        return offset
    }

    open override func draw(context: CGContext, point: CGPoint) {
        guard let dateLabel = dateLabel, let hourLabel = hourLabel else { return }

        let offset = self.offsetForDrawing(atPoint: point)
        let size = self.size

        var rect = CGRect(
            origin: CGPoint(
                x: point.x + offset.x,
                y: point.y + offset.y),
            size: size)
        rect.origin.x -= size.width / 2.0
        rect.origin.y -= size.height

        context.saveGState()

        context.setFillColor(color.cgColor)

        let x: CGFloat
        if isFirstValue {
            x = rect.origin.x + cornerValueOffset
        } else if isLastValue {
            x = rect.origin.x - cornerValueOffset
        } else {
            x = rect.origin.x
        }

        if offset.y > 0 {
            //arrow vertex
            context.beginPath()
            context.move(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height - 4))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + arrowSize.height - 4))
            let roundedRect = CGRect(x: x, y: rect.origin.y + arrowSize.height - 4, width: rect.width, height: rect.height)
            let bezierPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: 5)
            context.addPath(bezierPath.cgPath)
            context.drawPath(using: .fill)
        } else {
            context.beginPath()
            context.move(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: point.x,
                y: point.y))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width - arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height - 4))
            context.addLine(to: CGPoint(
                x: rect.origin.x + (rect.size.width + arrowSize.width) / 2.0,
                y: rect.origin.y + rect.size.height - arrowSize.height - 4))

            let roundedRect = CGRect(x: x, y: rect.origin.y - arrowSize.height - 4, width: rect.width, height: rect.height)
            let bezierPath = UIBezierPath(roundedRect: roundedRect, cornerRadius: 5)
            context.addPath(bezierPath.cgPath)
            context.drawPath(using: .fill)
        }

        if offset.y > 0 {
            rect.origin.y += self.insets.top + arrowSize.height
        } else {
            rect.origin.y += self.insets.top
        }

        if isFirstValue {
            rect.origin.x += 25
        }

        if isLastValue {
            rect.origin.x -= 25
        }
        rect.origin.y += offset.y > 0 ? -2 : -6
        dateLabel.draw(in: rect, withAttributes: _dateLabelDrawAttributes)

        rect.origin.y += offset.y > 0 ? 16 : 15
        hourLabel.draw(in: rect, withAttributes: _hourLabelDrawAttributes)

        UIGraphicsPushContext(context)

        UIGraphicsPopContext()

        context.restoreGState()
    }

    open override func refreshContent(entry: ChartDataEntry, highlight: Highlight) {
        setDateLabel(String(entry.y))
    }

    open func setDateLabel(_ newLabel: String) {
        dateLabel = newLabel

        _dateLabelDrawAttributes.removeAll()
        _dateLabelDrawAttributes[.font] = self.firstFont
        _dateLabelDrawAttributes[.paragraphStyle] = _paragraphStyle
        _dateLabelDrawAttributes[.foregroundColor] = self.firstTextColor

        _labelSize = dateLabel?.size(withAttributes: _dateLabelDrawAttributes) ?? CGSize.zero

        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }

    open func setHourLabel(_ newLabel: String) {
        hourLabel = newLabel

        _hourLabelDrawAttributes.removeAll()
        _hourLabelDrawAttributes[.font] = self.secondFont
        _hourLabelDrawAttributes[.paragraphStyle] = _paragraphStyle
        _hourLabelDrawAttributes[.foregroundColor] = self.secondTextColor

        _labelSize = dateLabel?.size(withAttributes: _hourLabelDrawAttributes) ?? CGSize.zero

        var size = CGSize()
        size.width = _labelSize.width + self.insets.left + self.insets.right
        size.height = _labelSize.height + self.insets.top + self.insets.bottom
        size.width = max(minimumSize.width, size.width)
        size.height = max(minimumSize.height, size.height)
        self.size = size
    }
}
