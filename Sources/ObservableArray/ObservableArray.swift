//
//  ObservableArray.swift
//  SalesProcurement
//
//  Created by Stadelman, Stan on 11/1/19.
//  Copyright © 2019 sstadelman. All rights reserved.
//

import Foundation
import Combine

class ObservableArray<Element: ObservableObject & Hashable & Identifiable>: Sequence, ObservableObject {
    
    typealias Observables = Array<Element>
    
    let objectWillChange = ObservableObjectPublisher()
    
    private var _elements = Observables()
    private var _cancellables: [Element.ID: AnyCancellable] = [:]
    
    init(_ elements: Observables) {
        self._elements = elements
        
        for element in _elements {
            _cancellables[element.id] = element.objectWillChange.sink(receiveValue: { [unowned self] _ in
                self.objectWillChange.send()
            })
        }
    }
    
    init() {}
    
    func append(_ element: Element) {
        _elements.append(element)
         _cancellables[element.id] = element.objectWillChange.sink(receiveValue: { [unowned self] _ in
            self.objectWillChange.send()
         })
    }
}

extension ObservableArray: Collection {
    typealias Index = Observables.Index
    typealias Element = Observables.Element
    
    var startIndex: Index { return _elements.startIndex }
    var endIndex: Index { return _elements.endIndex }
    
    subscript(index: Index) -> Element {
        return _elements[index]
    }
    func index(after i: Index) -> Index {
        return _elements.index(after: i)
    }
}

extension ObservableArray: RandomAccessCollection {}


