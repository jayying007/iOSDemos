//
//  WeekCalendarLayout.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/3.
//

import UIKit

let DaysPerWeek: Int = 7
let HoursPerDay: Int = 24
let HorizontalSpacing: CGFloat = 10
let HeightPerHour: CGFloat = 50
let WidthPerDay: CGFloat = 100
let DayHeaderHeight: CGFloat = 40
let HourHeaderWidth: CGFloat = 80

class WeekCalendarLayout: UICollectionViewLayout {
    override var collectionViewContentSize: CGSize {
        get {
            let contentWidth = HourHeaderWidth + (WidthPerDay * CGFloat(DaysPerWeek))
            let contentHeight = DayHeaderHeight + (HeightPerHour * CGFloat(HoursPerDay))

            return CGSize(width: contentWidth, height: contentHeight)
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        // Cells
        let visibleIndexPaths = indexPathsOfItems(inRect: rect)
        for indexPath in visibleIndexPaths {
            let attributes = layoutAttributesForItem(at: indexPath)
            layoutAttributes.append(attributes!)
        }
        // Supplementary views
        let dayHeaderViewIndexPaths = indexPathsOfDayHeaderViews(in: rect)
        for indexPath in dayHeaderViewIndexPaths {
            let attributes = layoutAttributesForSupplementaryView(ofKind: "DayHeaderView", at: indexPath)
            layoutAttributes.append(attributes!)
        }
        let hourHeaderViewIndexPaths = indexPathsOfHourHeaderViews(in: rect)
        for indexPath in hourHeaderViewIndexPaths {
            let attributes = layoutAttributesForSupplementaryView(ofKind: "HourHeaderView", at: indexPath)
            layoutAttributes.append(attributes!)
        }

        return layoutAttributes
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let dataSource = collectionView?.dataSource as! CalendarDataSource
        let event = dataSource.eventAt(indexPath)
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.frame = frameFor(event: event)
        return attributes
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)

        let totalWidth = collectionViewContentSize.width
        if elementKind == "DayHeaderView" {
            attributes.frame = CGRect(x: HourHeaderWidth + (WidthPerDay * CGFloat(indexPath.item)), y: 0, width: WidthPerDay, height: DayHeaderHeight)
            attributes.zIndex = -10
        } else if elementKind == "HourHeaderView" {
            attributes.frame = CGRect(x: 0, y: DayHeaderHeight + HeightPerHour * CGFloat(indexPath.item), width: totalWidth, height: HeightPerHour)
            attributes.zIndex = -10
        }

        return attributes
    }

    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}

extension WeekCalendarLayout {
    private func indexPathsOfItems(inRect rect: CGRect) -> [IndexPath] {
        let minVisibleDay = dayIndexFromXCoordinate(rect.minX)
        let maxVisibleDay = dayIndexFromXCoordinate(rect.maxX)
        let minVisibleHour = hourIndexFromYCoordinate(rect.minY)
        let maxVisibleHour = hourIndexFromYCoordinate(rect.maxY)

        let dataSource = collectionView?.dataSource as! CalendarDataSource
        return dataSource.indexPathsOfEventsBetween(minDayIndex: minVisibleDay, maxDayIndex: maxVisibleDay, minStartHour: minVisibleHour, maxStartHour: maxVisibleHour)
    }

    private func dayIndexFromXCoordinate(_ xPosition: CGFloat) -> Int {
        let dayIndex = max(0, (xPosition - HourHeaderWidth) / WidthPerDay)
        return Int(dayIndex)
    }

    private func hourIndexFromYCoordinate(_ yPosition: CGFloat) -> Int {
        let hourIndex = max(0, (yPosition - DayHeaderHeight) / HeightPerHour)
        return Int(hourIndex)
    }

    private func indexPathsOfDayHeaderViews(in rect: CGRect) -> [IndexPath] {
        if rect.minY > DayHeaderHeight {
            return [IndexPath]()
        }

        let minDayIndex = dayIndexFromXCoordinate(rect.minX)
        let maxDayIndex = dayIndexFromXCoordinate(rect.maxX)

        var indexPaths = [IndexPath]()
        for i in minDayIndex...maxDayIndex {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        return indexPaths
    }

    private func indexPathsOfHourHeaderViews(in rect: CGRect) -> [IndexPath] {
        if rect.minX > HourHeaderWidth {
            return [IndexPath]()
        }

        let minHourIndex = hourIndexFromYCoordinate(rect.minY)
        let maxHourIndex = hourIndexFromYCoordinate(rect.maxY)

        var indexPaths = [IndexPath]()
        for i in minHourIndex...maxHourIndex {
            indexPaths.append(IndexPath(item: i, section: 0))
        }
        return indexPaths
    }

    private func frameFor(event: CalendarEvent) -> CGRect {
        var frame = CGRect.zero
        frame.origin.x = HourHeaderWidth + WidthPerDay * CGFloat(event.day)
        frame.origin.y = DayHeaderHeight + HeightPerHour * CGFloat(event.startHour)
        frame.size.width = WidthPerDay
        frame.size.height = CGFloat(event.durationInHours) * HeightPerHour
        frame = CGRectInset(frame, HorizontalSpacing / 2, 0)

        return frame
    }
}
