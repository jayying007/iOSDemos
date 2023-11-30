//
//  WaterfallCell.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit

class WaterfallCell: UICollectionViewCell {
    lazy var numberLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(numberLabel)
        numberLabel.textColor = UIColor.red

        numberLabel.snp.makeConstraints { make in
            make.center.equalTo(self.snp.center)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
