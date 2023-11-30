//
//  CustomViewController.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit
import SnapKit

class CustomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "自定义插入、删除 cell 动画"
        let button1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let button2 = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(removeItem))
        navigationItem.rightBarButtonItems = [button1, button2]

        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }

        collectionView.delegate = self
        collectionView.dataSource = self
        // 注册需要的cell
        collectionView.register(ColorViewCell.self, forCellWithReuseIdentifier: "colorCell")
    }

    @objc func addItem() {
        colors.append(randomColor())
        collectionView.insertItems(at: [IndexPath(item: colors.count - 1, section: 0)])
    }

    @objc func removeItem() {
        colors.removeLast()
        collectionView.deleteItems(at: [IndexPath(item: colors.count, section: 0)])
    }

    // 懒加载一个collectionView
    lazy var collectionView: UICollectionView = {
        // 不在使用自带的 collectionViewLayout ，而是自定义的 PubuLayout
        let layout = PubuLayout()
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10

        cv.backgroundColor = UIColor.white
        cv.showsVerticalScrollIndicator = false

        return cv
    }()

}

// MARK: - 实现 collectionView 的 Delegate

extension CustomViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.performBatchUpdates({
            collectionView.deleteItems(at: [indexPath])
            colors.remove(at: indexPath.row)
        }) { (_) in
            collectionView.reloadData()
        }
    }
}

// MARK: - 实现 collectionView 的 DataSource

extension CustomViewController: UICollectionViewDataSource {

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorViewCell
        cell.backgroundColor = colors[indexPath.row]
        cell.numberLabel.text = "\(indexPath.row)"

        return cell
    }
}
