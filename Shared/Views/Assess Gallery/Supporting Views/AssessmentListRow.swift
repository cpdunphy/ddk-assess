//
//  AssessmentListRow.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 12/26/21.
//

import SwiftUI

struct AssessmentListRow : View {

    @EnvironmentObject var model : DDKModel
    @ScaledMetric var size: CGFloat = 1

    var type : AssessmentType
    @Binding var searchQuery : String
    @Binding var assessmentConfigureSelection : AssessmentType?
    
    
    var highlightedText : AttributedString? {
        
        let str = type.title
        let range = str.lowercased().range(of: searchQuery.lowercased())
        guard let range = range else { return nil }
        let lowerString = str[str.startIndex..<range.lowerBound]
        let middleString = str[range]
        let upperString = str[range.upperBound..<str.endIndex]
        
        var combo : String = ""
        
        // Append First Piece
        combo.append(contentsOf: lowerString)
        
        // Append Middle Pieces
        let middleStringComponents = middleString.components(separatedBy: " ")
        
        for i in 0..<middleStringComponents.count {
            let txt = middleStringComponents[i]
            
            if !txt.isEmpty {
                combo.append(contentsOf: "**" + txt + "**")
            }
            
            if i != middleStringComponents.count - 1 {
                combo.append(contentsOf: " ")
            }
        }
        
        // Append Last Piece
        combo.append(contentsOf: upperString)
        
        do {
            return try AttributedString(markdown: combo)
        } catch {
            print("Failed to create the attributed text")
        }
        return nil
    }
    
    
    var body : some View {
        HStack {
            Image(systemName: type.icon)
                .font(.title3)
                .foregroundColor(.white)
                .symbolVariant(.fill)
                .frame(width: 40 * size, height: 40 * size)
                .background(type.color, in: RoundedRectangle(cornerRadius: 8))
                .padding(.trailing, 4)
            
            
            if searchQuery.isEmpty {
                Text(type.title)
                    .foregroundColor(.primary)
            } else {
                Text(highlightedText ?? "Error")
                    .foregroundColor(.primary)
            }

            Spacer()   
        }
    }
}

struct AssessmentListRow_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentListRow(type: .timed, searchQuery: .constant(""), assessmentConfigureSelection: .constant(nil))
    }
}
