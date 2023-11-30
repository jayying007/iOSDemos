//
//  CircleLayout.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit

class CircleLayout: UICollectionViewLayout {
    private var attrsArray = [UICollectionViewLayoutAttributes]() // 用于存储布局属性

    override func prepare() {
        super.prepare()

        attrsArray.removeAll()
        let number = collectionView!.numberOfItems(inSection: 0)
        for i in 0 ..< number {
            let indexPath = IndexPath(item: i, section: 0)
            let attributes = layoutAttributesForItem(at: indexPath)!
            attrsArray.append(attributes)
        }
    }

    // 这个方法返回的是在rect范围内的布局属性，一般利用layoutAttributesForItemAtIndexPath的结果
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }

    // 这个方法需要返回indexPath位置对应的cell 的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attrs: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        let number = collectionView?.numberOfItems(inSection: 0)
        let radius: CGFloat = 80
        // 圆心位置
        let oX: CGFloat = collectionView!.frame.size.width * 0.5
        let oY: CGFloat = collectionView!.frame.size.height * 0.5

        attrs.size = CGSize(width: 60, height: 60)
        if number == 1 {
            attrs.center = CGPoint(x: oX, y: oY)
        } else {
            let angle: CGFloat = (2 * CGFloat(Double.pi) / CGFloat(number!)) * CGFloat(indexPath.item)
            let centerX: CGFloat = oX + radius * cos(angle)
            let centerY: CGFloat = oY - radius * sin(angle)
            attrs.center = CGPoint(x: centerX, y: centerY)
        }
        return attrs
    }
}
