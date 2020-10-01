//
//  AssessmentPicker.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import SwiftUI

struct AssessmentPicker: View {
    @Binding var type : AssessType
    
    var values : [AssessType] = [AssessType.timed, AssessType.count]
    
    var body: some View {
        Picker("What type of assessment?", selection: $type) {
            ForEach(values, id: \.self.hashValue) { value in
                Text(value.label).tag(value)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct AssessmentPicker_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentPicker(type: .constant(AssessType.timed))
    }
}
