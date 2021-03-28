//
//  Print.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 3/28/21.
//

import Foundation

public func print(_ object: String, filename: String = #file, line: Int = #line, column: Int = #column, function: String = #function) {
    #if DEBUG
    
    let index = filename.lastIndex(of: "/")
    
    var file : String? = nil
    if let index = index {
        file = String(filename.suffix(from: index))
    }
    
    var newFile : String? = nil
    if let file = file {
        let newIndex = file.firstIndex { $0 != "/" }
        
        if let newIndex = newIndex {
            newFile = String(file.suffix(from: newIndex))
        }
    }
    
    Swift.print("[\(newFile ?? "ErrorFileName")]: \(function)(\(line)): \(object)")
    
    #endif
}
