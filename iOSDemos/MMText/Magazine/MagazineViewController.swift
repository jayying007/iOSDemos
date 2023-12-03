//
//  ViewController.swift
//  CoreTextMagazine
//
//  Created by janezhuang on 2023/5/9.
//

import UIKit

class MagazineViewController: MMUIViewController {

    private var ctView: CTView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.ctView = CTView(frame: self.view.bounds)
        self.ctView?.contentInsetAdjustmentBehavior = .never
        self.view.addSubview(self.ctView!)
        // 1
        guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }

        do {
            let text = try String(contentsOfFile: file, encoding: .utf8)
            // 2
            let parser = MarkupParser()
            parser.parseMarkup(text)
            self.ctView?.buildFrames(withAttrString: parser.attrString, andImages: parser.images)

        } catch _ {
        }
    }

}
