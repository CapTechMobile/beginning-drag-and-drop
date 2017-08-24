//
//  TableViewController.swift
//  DragToMe
//
//  Created by Kyle Stevens on 8/14/17.
//  Copyright © 2017 Kyle Stevens. All rights reserved.
//

import UIKit

var californiaNames = ["Mavericks", "Yosemite", "El Capitan", "Sierra", "High Sierra"]

class TableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }
}

extension TableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return californiaNames.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = californiaNames[indexPath.row]

        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: nil)
        cell.textLabel?.text = name
        return cell
    }
}

extension TableViewController: UITableViewDelegate {

}

extension TableViewController: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let name = californiaNames[indexPath.row]

        // Must cast to NSString which conforms to NSItemProviderWriting
        let providableText = name as NSString

        let itemProvider = NSItemProvider(object: providableText)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
}

extension TableViewController: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}
