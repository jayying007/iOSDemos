//
//  PubuLayout.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit

// 完全自定义FlowLayout,但是仍以FlowLayout为基础
class PubuLayout: UICollectionViewFlowLayout {

    private var insertIndexPath = [IndexPath]()
    private var deleteIndexPath = [IndexPath]()

    // itemSize等可以再外面设置

    /**
     * 当collectionView的显示范围发生改变的时候，是否需要重新刷新布局
     * 一旦重新刷新布局，就会重新调用下面的方法：
     1.prepareLayout
     2.layoutAttributesForElementsInRect:方法
     */
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    /**
     *  用来做布局的初始化操作，不建议在init方法中进行布局的初始化操作
     */
    override func prepare() {
        super.prepare() // 一定要调用布局初始化
        scrollDirection = .vertical

        // 设置内边距
        sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

    // 增加操作时候的动画，设置cell的初始属性，结束属性默认就是在indexPath位置
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        if insertIndexPath.contains(itemIndexPath) {
            attributes?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), CGFloat(Double.pi))
            attributes?.center = CGPoint(x: CGRectGetMidX(collectionView!.bounds), y: CGRectGetMaxY(collectionView!.bounds))
        }

        return attributes
    }

    // 删除操作时候的属性，主要设置cell的最后位置的属性
    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        if deleteIndexPath.contains(itemIndexPath) {
            attributes?.transform = CGAffineTransformRotate(CGAffineTransformMakeScale(0.2, 0.2), CGFloat(Double.pi))
            attributes?.center = CGPoint(x: CGRectGetMidX(collectionView!.bounds), y: CGRectGetMaxY(collectionView!.bounds))
        }
        return attributes

    }

    override func prepare(forAnimatedBoundsChange oldBounds: CGRect) {
        print(#function)
    }

    override func prepare(forCollectionViewUpdates updateItems: [UICollectionViewUpdateItem]) {
        print(#function)
        super.prepare(forCollectionViewUpdates: updateItems)

        insertIndexPath = [IndexPath]()
        deleteIndexPath = [IndexPath]()
        for update in updateItems {
            switch update.updateAction {
            case .insert:
                insertIndexPath.append(update.indexPathAfterUpdate!)
            case .delete:
                deleteIndexPath.append(update.indexPathBeforeUpdate!)
            default:
                print("error")
            }
        }
    }
}
