//
//  Binding.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 11/5/21.
//

import Foundation
import SwiftUI

extension Binding where Value == Int {

    static func ?? (lhs: Binding<Value?>, rhs: Value) -> Binding<Value> {
        return Binding {
            return lhs.wrappedValue ?? rhs
        } set: { (val) in
            lhs.wrappedValue = val == rhs ? nil : val
        }
    }
}

extension Binding where Value == String {

    static func ?? (lhs: Binding<Value?>, rhs: Value) -> Binding<Value> {
        return Binding {
            return lhs.wrappedValue ?? rhs
        } set: { (val) in
            lhs.wrappedValue = val == rhs ? nil : val
        }
    }
}

extension Binding where Value == Bool {

    static func ?? (lhs: Binding<Value?>, rhs: Value) -> Binding<Value> {
        return Binding {
            return lhs.wrappedValue ?? rhs
        } set: { (val) in
            lhs.wrappedValue = val == rhs ? nil : val
        }
    }
}

extension Binding {

    static func ?? (lhs: Binding<Value?>, rhs: Value) -> Binding<Value> {
        return Binding {
            return lhs.wrappedValue ?? rhs
        } set: { (val) in
            print("Setting \(String(describing: lhs.wrappedValue)) to \(rhs), but there is no nil option.")
            lhs.wrappedValue = val
        }
    }

}

extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}

extension Optional where Wrapped == Int {
    var _bound: Int? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: Int {
        get {
            return _bound ?? 0
        }
        set {
            //            _bound = newValue == 0 ? nil : newValue
            _bound = newValue
        }
    }
}

extension Optional where Wrapped == Bool {
    var _bound: Bool? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: Bool {
        get {
            return _bound ?? false
        }
        set {
            _bound = newValue
            //            if let newValue = newValue {
            //                _bound = newValue
            //            } else {
            //                _bound = nil
            //            }
        }
    }
}

extension Optional where Wrapped == Date {
    var _bound: Date? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: Date {
        get {
            return _bound ?? Date()
        }
        set {
            _bound = newValue  // ? nil : newValue
        }
    }
}
