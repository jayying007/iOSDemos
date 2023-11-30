//
//  LineCircleCell.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit

class LineCircleCell: UICollectionViewCell {
    var lineImageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(lineImageView)

        lineImageView.snp.makeConstraints { make in
            make.edges.equalTo(self.snp.edges)
        }

        layer.cornerRadius = 30
        layer.masksToBounds = true
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
