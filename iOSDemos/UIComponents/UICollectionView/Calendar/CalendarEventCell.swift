//
//  CalendarEventCell.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/3.
//

import UIKit

class CalendarEventCell: UICollectionViewCell {
    lazy var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        layer.cornerRadius = 8
        layer.borderWidth = 1
        layer.borderColor = UIColor(red: 0.8, green: 0, blue: 0, alpha: 1).cgColor

        addSubview(titleLabel)
        titleLabel.textColor = UIColor.gray
        titleLabel.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
