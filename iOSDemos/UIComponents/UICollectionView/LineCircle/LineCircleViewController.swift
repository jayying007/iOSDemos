//
//  LineCircleViewController.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit

class LineCircleViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.gray
        view.addSubview(collectionView)

        let button1 = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        let button2 = UIBarButtonItem(title: "切换布局", style: .plain, target: self, action: #selector(changeLayout))
        navigationItem.rightBarButtonItems = [button1, button2]

        collectionView.delegate = self
        collectionView.dataSource = self
        // 注册需要的cell
        collectionView.register(LineCircleCell.self, forCellWithReuseIdentifier: "lineCell")
    }

    // MARK: - Button 方法
    // 切换布局
    @objc func changeLayout() {
        if collectionView.collectionViewLayout.isKind(of: LineLayout.self) {
            collectionView.setCollectionViewLayout(CircleLayout(), animated: true)
        } else {
            collectionView.setCollectionViewLayout(LineLayout(), animated: true)
        }
    }

    // 增加
    @objc func addItem() {
        let a = UInt32(dota2Avart.count) < 13 ? UInt32(dota2Avart.count) : 13
        let picNumber = Int(arc4random_uniform(a))
        dota2Avart.insert("dota2-" + "\(picNumber)", at: picNumber)

        let index = Int(arc4random_uniform(UInt32(dota2Avart.count)))
        collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
    }

    // 懒加载一个collectionView
    lazy var collectionView: UICollectionView = {
        // 不在使用自带的 collectionViewLayout ，而是自定义的 PubuLayout
        let layout = CircleLayout()
        let collectionW: CGFloat = self.view.frame.size.width
        let collectionH: CGFloat = 300.0
        let frame = CGRect(x: 0, y: 150, width: collectionW, height: collectionH)
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)

        cv.backgroundColor = UIColor.cyan
        cv.showsHorizontalScrollIndicator = false

        return cv
    }()
}

// MARK: - 实现data source
extension LineCircleViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dota2Avart.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "lineCell", for: indexPath) as! LineCircleCell
        cell.lineImageView.image = UIImage(named: dota2Avart[indexPath.item])

        return cell
    }
}

extension LineCircleViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dota2Avart.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}
