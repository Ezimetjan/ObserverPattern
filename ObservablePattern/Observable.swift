//
//  Observable.swift
//  ObservablePattern
//
//  Created by Jonathan Wight on 10/23/15.
//  Copyright © 2015 schwa.io. All rights reserved.
//

import Foundation

typealias ObservableCallback = Void -> Void

protocol ObservableType {
    typealias ValueType
    var value: ValueType { get set }
    var observers: NSMapTable { get }
    
    func registerObserver(observer: AnyObject, closure: ObservableCallback)
    func unregisterObserver(observer: AnyObject)
    func notifyObservers()
    
    init(_ value: ValueType)
}

extension ObservableType {
    func registerObserver(observer: AnyObject, closure: ObservableCallback) {
        observers.setObject(Box(closure), forKey: observer)
    }
    
    func unregisterObserver(observer: AnyObject) {
        observers.removeObjectForKey(observer)
    }
    
    func notifyObservers() {
        let boxes = observers.map() {
            (key, value) in
            return value as! Box <ObservableCallback>
        }
        boxes.forEach() {
            $0.value()
        }
    }
}

class ObservableProperty <ValueType>: ObservableType {
    let observers = NSMapTable.weakToStrongObjectsMapTable()
    
    var value: ValueType {
        didSet {
            notifyObservers()
        }
    }
    
    required init(_ value: ValueType) {
        self.value = value
    }
}

// MARK: -

public class Box <T> {
    public let value: T
    public init(_ value: T) {
        self.value = value
    }
}

// MARK: -

extension NSMapTable: SequenceType {

    public typealias Generator = _Generator

    public struct _Generator: GeneratorType {
        public typealias Element =  (AnyObject, AnyObject)

        let keyEnumerator: NSEnumerator
        let objectEnumerator: NSEnumerator

        init(mapTable: NSMapTable) {
            keyEnumerator = mapTable.keyEnumerator()
            objectEnumerator = mapTable.objectEnumerator()!
        }

        public mutating func next() -> Element? {
            guard let nextKey = keyEnumerator.nextObject(), let nextObject = objectEnumerator.nextObject() else {
                return nil
            }
            return (nextKey, nextObject)
        }
    }

    public func generate() -> _Generator {
        return _Generator(mapTable: self)
    }
}
