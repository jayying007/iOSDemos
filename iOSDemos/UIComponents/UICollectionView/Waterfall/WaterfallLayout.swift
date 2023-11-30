//
//  WaterfallLayout.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit

// 代理 用于接口设置 layout不依赖数据
@objc protocol WaterfallLayoutDelegate {
    func waterfallLayout(_ waterfallLayout: WaterfallLayout, heightForItemAtIndex index: Int) -> CGFloat
    // 设置代理来间接设置layout布局中一些属性
    @objc optional func columnCountInWaterfallLayout(waterfallLayout: WaterfallLayout) -> Int
    @objc optional func columnMarginInWaterfallLayout(waterfallLayout: WaterfallLayout) -> CGFloat
    @objc optional func rowMarginInWaterfallLayout(waterfallLayout: WaterfallLayout) -> CGFloat
    @objc optional func edgeInsetInWaterfallLayout(waterfallLayout: WaterfallLayout) -> UIEdgeInsets
}

// 默认列数
let DefaultColumnCount = 3
let DefaultColumnMargin: CGFloat = 10
let DefaultRowMargin: CGFloat = 10
let DefaultEdgeInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

class WaterfallLayout: UICollectionViewLayout {
    weak var delegate: WaterfallLayoutDelegate?
    // 用于保存属性数组
    lazy var attrsArray = [UICollectionViewLayoutAttributes]()
    // 存放所有列的当前高度
    lazy var columHeights = [CGFloat]()
    // 存放内容高度
    lazy var contentHeight: CGFloat = 0

    // MARK: - 常见数据处理
    func rowMargin() -> CGFloat {
        // 判断是否实现了可选的代理方法
        if let mydelegate = delegate {
            if let rowMarginInWaterfallLayout = mydelegate.rowMarginInWaterfallLayout {
                return rowMarginInWaterfallLayout(self)
            }
        }
        return DefaultRowMargin
    }

    func columnMargin() -> CGFloat {
        if let mydelegate = delegate {
            if let columnMarginInWaterfallLayout = mydelegate.columnMarginInWaterfallLayout {
                return columnMarginInWaterfallLayout(self)
            }
        }
        return DefaultColumnMargin
    }

    func columnCount() -> Int {
        if let mydelegate = delegate {
            if let columnCountInWaterfallLayout = mydelegate.columnCountInWaterfallLayout {
                return columnCountInWaterfallLayout(self)
            }
        }
        return DefaultColumnCount
    }

    func edgeInsets() -> UIEdgeInsets {
        if let mydelegate = delegate {
            if let edgeInserInwaterfallLayout = mydelegate.edgeInsetInWaterfallLayout {
                return edgeInserInwaterfallLayout(self)
            }
        }
        return DefaultEdgeInsets
    }

    // 初始化
    override func prepare() {
        super.prepare()

        // 清楚一起计算的所有高度
        columHeights.removeAll()

        for _ in 0..<columnCount() {
            columHeights.append(edgeInsets().top)
        }

        // 清除所有的属性
        attrsArray.removeAll()

        // 开始创建每一个cell对应的布局属性
        let count: Int = (collectionView?.numberOfItems(inSection: 0))!
        for i in 0..<count {
            // 创建位置
            let indexpath = IndexPath(item: i, section: 0)
            // 创建布局属性 获取indexPath位置cell对应的布局属性
            let attrs: UICollectionViewLayoutAttributes = layoutAttributesForItem(at: indexpath)!
            attrsArray.append(attrs)
        }
    }

    // 布局在前面准备好，layoutAttributesForElementsInRect 调用频繁
    // 决定 cell 的布局
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrsArray
    }

    // 返回indexPath位置cell对应的布局属性
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // 创建布局属性
        let attrs: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)

        // collectionView的宽度
        let collectionViewW: CGFloat = (collectionView?.frame.size.width)!

        // 设置布局属性
        let w: CGFloat = (collectionViewW - edgeInsets().left - edgeInsets().right - (CGFloat(columnCount()) - 1) * columnMargin()) / CGFloat(columnCount())
        let h: CGFloat = (delegate?.waterfallLayout(self, heightForItemAtIndex: indexPath.item))!

        // 找出高度最小的那一列
        var destColumn: Int = 0
        var minColumnHeight: CGFloat = columHeights[destColumn]
        for i in 1..<columnCount() {
            let columnHeight: CGFloat = columHeights[i]
            if minColumnHeight > columnHeight {
                minColumnHeight = columnHeight
                destColumn = i
            }
        }

        let x: CGFloat = edgeInsets().left + CGFloat(destColumn) * (w + columnMargin())
        var y: CGFloat = minColumnHeight

        if y != edgeInsets().top {
            y += rowMargin()
        }

        attrs.frame = CGRect(x: x, y: y, width: w, height: h)
        // 更新最短那列的高度
        columHeights[destColumn] = CGRectGetMaxY(attrs.frame)

        // 记录内容的高度
        let columnHeigth: CGFloat = columHeights[destColumn]
        if contentHeight < columnHeigth {
            contentHeight = columnHeigth
        }

        return attrs
    }

    override var collectionViewContentSize: CGSize {
        get {
            return CGSize(width: 0, height: contentHeight + edgeInsets().bottom)
        }
    }
}
