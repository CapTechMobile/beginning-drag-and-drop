//
//  DropViewController.swift
//  DragToMe
//
//  Created by Kyle Stevens on 6/10/17.
//  Copyright © 2017 Kyle Stevens. All rights reserved.
//

import UIKit

class DropViewController: UIViewController {
    @IBOutlet weak var dropImageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        dropImageView.pasteConfiguration = UIPasteConfiguration(acceptableTypeIdentifiers: ["public.jpeg"])
        dropImageView.isUserInteractionEnabled = true
    }

    override func paste(itemProviders: [NSItemProvider]) {
        if let item = itemProviders.first {
            item.loadObject(ofClass: UIImage.self, completionHandler: { providedImage, error in
                guard let image = providedImage as? UIImage else {
                    fatalError("Invalid image type")
                }

                DispatchQueue.main.async {
                    self.dropImageView.image = image
                }
            })
        }
    }

//    override func canPaste(_ itemProviders: [NSItemProvider]) -> Bool {
//        let coinFlip = arc4random_uniform(2) == 0
//        return coinFlip // drive users crazy
//    }
}
