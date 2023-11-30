//
//  CollectionEntryViewController.swift
//  iOSDemos
//
//  Created by janezhuang on 2023/11/30.
//

import UIKit

var dota2Avart: [String] = [String]()
var dota2Pic: [String] = [String]()
var colors: [UIColor] = [UIColor]()

func randomColor() -> UIColor {
    let r = CGFloat(arc4random() % 256) / 255
    let g = CGFloat(arc4random() % 256) / 255
    let b = CGFloat(arc4random() % 256) / 255
    return UIColor(red: r, green: g, blue: b, alpha: 1)
}

func InitDataModel() {
    for _ in 0...40 {
        colors.append(randomColor())
    }
    // 简单的初始化两个数组后面使用
    for i in 0...30 {
        dota2Pic.append("DOTA2_" +  "\(i)")
    }
    for i in 0...13 {
        dota2Avart.append("dota2-" + "\(i)")
    }
}

class CollectionEntryViewController: UIViewController {

    private var tableView: UITableView?
    private var datas: [String] = ["1. 最基本的流水线布局", "2. 自定义插入、删除 cell 的动画", "3. 线性布局和圆形布局", "4. 瀑布流布局", "5. 日历视图"]

    override func viewDidLoad() {
        super.viewDidLoad()

        InitDataModel()

        tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView?.dataSource = self
        tableView?.delegate = self
        self.view.addSubview(tableView!)
    }

}

extension CollectionEntryViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = datas[indexPath.row]

        return cell!
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            let vc = BaseViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 1:
            let vc = CustomViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 2:
            let vc = LineCircleViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3:
            let vc = WaterfallViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 4:
            let vc = CalendarViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        default:
            print("default")
        }
    }
}
