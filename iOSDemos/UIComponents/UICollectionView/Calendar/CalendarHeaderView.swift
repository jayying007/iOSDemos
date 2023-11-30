//
//  CalendarHeaderView.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/3.
//

import UIKit

class CalendarHeaderView: UICollectionReusableView {
    lazy var titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(titleLabel)
        titleLabel.textColor = UIColor.gray
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.centerY)
            make.left.equalTo(self.snp.left).offset(16)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
