//
//  Statistics.swift
//  Diadochokinetic Assess (iOS)
//
//  Created by Collin Dunphy on 12/1/21.
//

import SwiftUI

struct Statistics: View {
    
    @EnvironmentObject var ddk : DDKModel
    
    var body: some View {
        List {
            Section {
            ForEach(AssessmentType.allCases, id: \.self) { type in
                HStack {
                    Label(
                        title: {
                            Text(type.title)
                        },
                        icon: {
                            Image(systemName: type.icon)
                                .symbolVariant(.fill)
                                .foregroundColor(type.color)
                        }
                    )
                    
                    Spacer()
                    Text("\(ddk.retreiveLifetimeTotals()[type] ?? 0)")
                }
            }
                
            } footer: {
                Text("These are the statistics over your entire use of this app, reseting the counter will have no effect on these values.")
            }
            
            
        }
        .navigationTitle("Statistics")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct Statistics_Previews: PreviewProvider {
    static var previews: some View {
        Statistics()
    }
}
