//
//  ViewController.swift
//  CoreTextMagazine
//
//  Created by janezhuang on 2023/5/9.
//

import UIKit

class MagazineViewController: MMUIViewController {

    override func loadView() {
        self.view = CTView(frame: self.navigationController!.view.bounds)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // 1
        guard let file = Bundle.main.path(forResource: "zombies", ofType: "txt") else { return }

        do {
            let text = try String(contentsOfFile: file, encoding: .utf8)
            // 2
            let parser = MarkupParser()
            parser.parseMarkup(text)
            (view as? CTView)?.buildFrames(withAttrString: parser.attrString, andImages: parser.images)

        } catch _ {
        }
    }

}
