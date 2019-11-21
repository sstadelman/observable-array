//
//  ObservableArray.swift
//  SalesProcurement
//
//  Created by Stadelman, Stan on 11/1/19.
//  Copyright © 2019 sstadelman. All rights reserved.
//

import Foundation
import Combine

public final class ObservableArray<Element: ObservableObject & Hashable & Identifiable>: Sequence, ObservableObject {
    
    public typealias Observables = Array<Element>
    
    public let objectWillChange = ObservableObjectPublisher()
    
    private var _elements = Observables()
    private var _cancellables: [Element.ID: AnyCancellable] = [:]
    
    public init(_ elements: Observables) {
        self._elements = elements
        
        for element in _elements {
            _cancellables[element.id] = element.objectWillChange.sink(receiveValue: { [unowned self] _ in
                self.objectWillChange.send()
            })
        }
    }
    
    public init() {}
    
    public func append(_ element: Element) {
        _elements.append(element)
         _cancellables[element.id] = element.objectWillChange.sink(receiveValue: { [unowned self] _ in
            self.objectWillChange.send()
         })
    }
}

extension ObservableArray: Collection {
    public typealias Index = Observables.Index
    public typealias Element = Observables.Element
    
    public var startIndex: Index { return _elements.startIndex }
    public var endIndex: Index { return _elements.endIndex }
    
    public subscript(index: Index) -> Element {
        return _elements[index]
    }
    public func index(after i: Index) -> Index {
        return _elements.index(after: i)
    }
}

extension ObservableArray: RandomAccessCollection {}


