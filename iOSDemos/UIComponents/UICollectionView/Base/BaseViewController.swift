//
//  BaseViewController.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit
import SnapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "DOTA2 英雄"

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }

        collectionView.delegate = self
        collectionView.dataSource = self

        // 注册需要的cell
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "myImageCell")
        // 添加长按手势来拖动cell
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(longPress:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }

    // MARK: - 长按手势
    @objc func longPressAction(longPress: UILongPressGestureRecognizer) {

        let point: CGPoint = longPress.location(in: collectionView)
        print(point)

        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }

        switch longPress.state {
        case .began:
            collectionView.beginInteractiveMovementForItem(at: indexPath)
            print("Began")
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(point)
            print("Changed")
        case .ended:
            collectionView.endInteractiveMovement()
            print("Ended")
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

    // 懒加载一个collectionView
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        cv.backgroundColor = UIColor.orange
        cv.showsVerticalScrollIndicator = false
        flowLayout.scrollDirection = .vertical

        return cv

    }()

}

extension BaseViewController: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return dota2Avart.count
        case 1:
            return dota2Pic.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "myImageCell", for: indexPath) as! ImageCollectionViewCell

        switch indexPath.section {
        case 0:
            cell.imageView.image = UIImage(named: dota2Avart[indexPath.item])
            cell.nameLabel.text = "第\(indexPath.item)个图像"
        case 1:
            cell.imageView.image = UIImage(named: dota2Pic[indexPath.item])
            cell.nameLabel.text = "第\(indexPath.item)个图像"
        default:
            cell.imageView.image = UIImage(named: dota2Avart[indexPath.item])
            cell.nameLabel.text = "第\(indexPath.item)个图像"
        }

        return cell
    }

    // 移动结束后调用的方法
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dota2Pic.remove(at: sourceIndexPath.item)
        let imageName = dota2Pic[sourceIndexPath.item]
        dota2Pic.insert(imageName, at: destinationIndexPath.item)
    }
}

// MARK: - 实现 UICollectionViewDelegateFlowLayout 方法

extension BaseViewController: UICollectionViewDelegateFlowLayout {
    // 内边距
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 15, left: 12, bottom: 20, right: 20)
        } else {
            return UIEdgeInsets(top: 15, left: 4, bottom: 20, right: 4)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    // 可以根据不同的section设置不同的item的大小，直接在属性或storyboard中不好设置
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 100, height: 121)
        case 1:
            return CGSize(width: 120, height: 221)
        default:
            return CGSize.zero
        }
    }
}

// MARK: - UICollectionView 的 Delegate 方法
extension BaseViewController: UICollectionViewDelegate {

    // 设置选中某个cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // 删除操作 自带动画，可以自定义
        if indexPath.section == 0 {
            dota2Avart.remove(at: indexPath.row)
        } else {
            dota2Pic.remove(at: indexPath.row)
        }
        collectionView.deleteItems(at: [indexPath])
    }

    // 高亮动画
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let selectCell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) {
            selectCell?.transform = CGAffineTransformMakeScale(2.0, 2.0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let selectCell = collectionView.cellForItem(at: indexPath)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: .curveEaseInOut) {
            selectCell?.transform = CGAffineTransformMakeScale(1.0, 1.0)
        }
    }
}
