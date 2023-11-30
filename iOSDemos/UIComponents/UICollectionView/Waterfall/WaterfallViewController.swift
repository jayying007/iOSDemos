//
//  WaterfallViewController.swift
//  demo-CollectionView
//
//  Created by janezhuang on 2023/1/2.
//

import UIKit

class WaterfallViewController: UIViewController {

    // 定义一个数组保存数据
    var colorsData = [UIColor]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupRefresh()
    }

    private func setupUI() {
        title = "自定义瀑布流布局"
        view.addSubview(collectionView)

        collectionView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(self.view)
        }
        // 注册cell
        collectionView.register(WaterfallCell.self, forCellWithReuseIdentifier: "waterfallCell")
    }

    private func setupRefresh() {
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(loadNewColors))
        collectionView.mj_header?.beginRefreshing()

        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreColors))
        collectionView.mj_footer?.isHidden = true
    }

    @objc func loadNewColors() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.colorsData.removeAll()
            self.colorsData.append(contentsOf: colors)

            self.collectionView.reloadData()
            self.collectionView.mj_header?.endRefreshing()
            self.collectionView.mj_footer?.isHidden = false
        }
    }

    @objc func loadMoreColors() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.colorsData.append(contentsOf: colors)

            self.collectionView.reloadData()
            self.collectionView.mj_footer?.endRefreshing()
        }
    }

    lazy var collectionView: UICollectionView = {
        let layout = WaterfallLayout()

        let cv: UICollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        layout.delegate = self

        return cv
    }()

}

extension WaterfallViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorsData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "waterfallCell", for: indexPath) as! WaterfallCell
        cell.backgroundColor = colorsData[indexPath.item]
        cell.numberLabel.text = "\(indexPath.item)"

        return cell
    }
}

// MARK: - 自定义的代理 设置 高度 WaterfallLayoutDelegate
// 直接通过ViewController来更改layout 的属性，具有更好的独立性
extension WaterfallViewController: WaterfallLayoutDelegate {

    func waterfallLayout(_ waterfallLayout: WaterfallLayout, heightForItemAtIndex index: Int) -> CGFloat {
        return 50.0 + CGFloat(arc4random_uniform(100))
    }

    func rowMarginInWaterfallLayout(waterfallLayout: WaterfallLayout) -> CGFloat {
        return 10
    }

    func columnMarginInWaterfallLayout(waterfallLayout: WaterfallLayout) -> CGFloat {
        return 10
    }

    func columnCountInWaterfallLayout(waterfallLayout: WaterfallLayout) -> Int {
        return 4
    }

    func edgeInsetInWaterfallLayout(waterfallLayout: WaterfallLayout) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }

}
