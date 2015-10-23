//
//  ViewController.swift
//  ObservablePattern
//
//  Created by Jonathan Wight on 10/23/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var label: NSTextField?

    override func viewDidLoad() {
        super.viewDidLoad()

        let model = Model.sharedInstance
        model.currentDate.observable.registerObserver(self) {
            [weak self] in
            self?.label?.objectValue = model.currentDate.value
        }
    }
}

