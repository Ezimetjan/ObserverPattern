//
//  Model.swift
//  ObservablePattern
//
//  Created by Jonathan Wight on 10/23/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

class Model {

    static let sharedInstance = Model()

    let currentDate = ObservableProperty(NSDate())

    init() {
        tick()
    }

    func tick() {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1 / 30 * 1_000_000_000), dispatch_get_main_queue()) {
            [weak self] in
            self?.tick()
        }
        currentDate.value = NSDate()
    }
}