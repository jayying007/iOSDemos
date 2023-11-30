//
//  ImageCollectionViewCell.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit
import SnapKit

class ImageCollectionViewCell: UICollectionViewCell {
    lazy var imageView = UIImageView()
    lazy var nameLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        backgroundColor = UIColor.cyan

        addSubview(imageView)
        addSubview(nameLabel)

        imageView.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).offset(4)
            make.left.equalTo(self.snp.left).offset(4)
            make.right.equalTo(self.snp.right).offset(-4)
        }
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalTo(self.snp.bottom)
            make.height.equalTo(32)
            make.centerX.equalTo(self.snp.centerX)
        }

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
}
