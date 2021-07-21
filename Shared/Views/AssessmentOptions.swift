//
//  AssessmentOptions.swift
//  AssessmentOptions
//
//  Created by Collin Dunphy on 7/18/21.
//

import SwiftUI

struct AssessmentOptions: View {
    
    @EnvironmentObject var model : DDKModel
    
    @Environment(\.dismiss) var dismiss
    
    
    var type : AssessmentType
    
    var body: some View {
        Form {
            Section {
                Toggle(
                    "\(Image(systemName: "star.fill")) Favorite",
                    isOn: Binding<Bool>(
                        get: {
                            model.assessmentTypeIsFavorite(type)
                        },
                        set: { newValue in
                            model.toggleFavoriteStatus(type)
                        }
                    )
                )
            }
            
            Section {
                Picker("Set the Seconds", selection: .constant(10)) {
                    ForEach(1...60, id: \.self) {
                        Text("\($0)")
                            .tag($0)
                    }
                }.pickerStyle(.automatic)
                
    //            Stepper("Countdown Time: \(countdown) \(countdown == 1 ? "second" : "seconds")", value: $countdown, in: 0...60)
                
                Stepper("Countdown Time: \(3)", value: .constant(3))

                Toggle("Show Decimal on Timer", isOn: .constant(true))
            }
            
            Section {
                Toggle("Show BPM vs BPS", isOn: .constant(true))
            }
            
        }
        .navigationTitle(type.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Text("Done").bold()
                }
            }
            
        }
    }
}

struct AssessmentOptions_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentOptions(type: .timed)
    }
}
