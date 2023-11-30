//
//  CalendarViewController.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/3.
//

import UIKit

class CalendarViewController: UIViewController {

    lazy var dataSource = CalendarDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }

    private func setupUI() {
        title = "日历视图"
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        // 注册cell
        collectionView.register(CalendarEventCell.self, forCellWithReuseIdentifier: "CalendarEventCell")
        collectionView.register(CalendarHeaderView.self, forSupplementaryViewOfKind: "DayHeaderView", withReuseIdentifier: "HeaderView")
        collectionView.register(CalendarHeaderView.self, forSupplementaryViewOfKind: "HourHeaderView", withReuseIdentifier: "HeaderView")

        dataSource.configureCellBlock = { cell, _, event in
            cell.titleLabel.text = event.title
        }
        dataSource.configureHeaderViewBlock = { headerView, kind, indexPath in
            if kind == "DayHeaderView" {
                headerView.titleLabel.text = String(format: "Day %d", indexPath.item + 1)
            } else if kind == "HourHeaderView" {
                headerView.titleLabel.text = String(format: "%2d:00", indexPath.item + 1)
            }
        }
    }

    lazy var collectionView: UICollectionView = {
        let layout = WeekCalendarLayout()
        let cv: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.dataSource = dataSource

        return cv
    }()

}
