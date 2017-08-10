//
//  DragViewController.swift
//  DragToMe
//
//  Created by Kyle Stevens on 6/10/17.
//  Copyright © 2017 Kyle Stevens. All rights reserved.
//

import UIKit

class DragViewController: UIViewController {
    @IBOutlet weak var dragLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        let dragInteraction = UIDragInteraction(delegate: self)
        dragLabel.addInteraction(dragInteraction)

        // Must enable user interaction or else drags will not work
        dragLabel.isUserInteractionEnabled = true
    }
}

extension DragViewController: UIDragInteractionDelegate {
    // This is the only delegate function we need
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let text = dragLabel.text, text != "" else {
            // The drag will not be performed
            return []
        }

        // Must cast to NSString which conforms to NSItemProviderWriting
        let providableText = text as NSString

        let itemProvider = NSItemProvider(object: providableText)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
}
