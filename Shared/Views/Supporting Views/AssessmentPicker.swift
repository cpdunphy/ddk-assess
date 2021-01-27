//
//  AssessmentPicker.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import SwiftUI

struct AssessmentPicker: View {
    
    @EnvironmentObject var model : DDKModel
    
    var values : [AssessType] = [AssessType.timed, AssessType.count]
    
    var body: some View {
        Picker("What type of assessment?", selection: $model.assessType) {
            ForEach(values, id: \.self.rawValue) { value in
                Text(value.label).tag(value)
            }
        }.pickerStyle(SegmentedPickerStyle())
    }
}

struct AssessmentPicker_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentPicker()
    }
}
