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
    @Binding var assessmentSettingsSelection : AssessmentType?
    
    
    func highlightedText(in str : String) -> AttributedString? {
        var attributedString : AttributedString = AttributedString(str.lowercased())
        print(attributedString)
        if let range = attributedString.range(of: searchQuery.lowercased()) {
            
            attributedString[range].foregroundColor = .accentColor
            
            return attributedString
        } else {
            return nil
        }
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
                Text(highlightedText(in: type.title) ?? "nil")
                    .foregroundColor(.primary)
            }

            Spacer()
            
        }//.padding(.vertical, 2)
    }
}

struct AssessmentListRow_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentListRow(type: .timed, searchQuery: .constant(""), assessmentSettingsSelection: .constant(nil))
    }
}
