//
//  CalendarEvent.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/3.
//

import UIKit

protocol CalendarEvent {
    var title: String { get set }
    var day: Int { get set }
    var startHour: Int { get set }
    var durationInHours: Int { get set }
}

class SampleCalendarEvent: CalendarEvent {
    var title: String

    var day: Int

    var startHour: Int

    var durationInHours: Int

    class func randomEvent() -> CalendarEvent {
        let randomId = arc4random_uniform(1000)
        let title = String(format: "Event #%u", randomId)

        let randomDay = Int(arc4random_uniform(7))
        let randomStartHour = Int(arc4random_uniform(18))
        let randomDuration = Int(arc4random_uniform(5) + 1)

        return SampleCalendarEvent(title: title, day: randomDay, startHour: randomStartHour, durationInHours: randomDuration)
    }

    init(title: String, day: Int, startHour: Int, durationInHours: Int) {
        self.title = title
        self.day = day
        self.startHour = startHour
        self.durationInHours = durationInHours
    }
}
