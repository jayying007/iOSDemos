//
//  CalendarDataSource.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/3.
//

import UIKit

class CalendarDataSource: NSObject, UICollectionViewDataSource {

    typealias ConfigureCellBlock = (_ cell: CalendarEventCell, _ indexPath: IndexPath, _ event: CalendarEvent) -> Void
    typealias ConfigureHeaderViewBlock = (_ headerView: CalendarHeaderView, _ kind: String, _ indexPath: IndexPath) -> Void

    var configureCellBlock: ConfigureCellBlock?
    var configureHeaderViewBlock: ConfigureHeaderViewBlock?

    private lazy var events: [CalendarEvent] = {
        var array = [CalendarEvent]()
        for _ in 0..<12 {
            let event = SampleCalendarEvent.randomEvent()
            array.append(event)
        }
        return array
    }()

    func eventAt(_ indexPath: IndexPath) -> CalendarEvent {
        return events[indexPath.item]
    }

    func indexPathsOfEventsBetween(minDayIndex: Int, maxDayIndex: Int, minStartHour: Int, maxStartHour: Int) -> [IndexPath] {
        var indexPaths = [IndexPath]()
        for (index, event) in events.enumerated() {
            if event.day >= minDayIndex && event.day <= maxDayIndex && event.startHour >= minStartHour && event.startHour <= maxStartHour {
                indexPaths.append(IndexPath(item: index, section: 0))
            }
        }
        return indexPaths
    }

    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let event = events[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarEventCell", for: indexPath) as! CalendarEventCell
        configureCellBlock?(cell, indexPath, event)

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderView", for: indexPath) as! CalendarHeaderView
        configureHeaderViewBlock?(headerView, kind, indexPath)

        return headerView
    }
}
