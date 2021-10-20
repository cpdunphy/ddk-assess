//
//  AssessmentTaker.swift
//  AssessmentTaker
//
//  Created by Collin Dunphy on 7/18/21.
//

import SwiftUI

struct AssessmentTaker: View {
    
    @Environment(\.dismiss) var dismiss
    
    @State var assessmentSettingsSelection : AssessmentType? = nil
    
    var type : AssessmentType
    
    @ViewBuilder
    var statsDisplay : some View {
        switch type {
        case .timed:
            EmptyView()
        case .count:
            EmptyView()
        case .heartRate:
            Stats.HeartRate()
        }
    }
    
    @ViewBuilder
    var buttons : some View {
        switch type {
        case .timed:
            EmptyView()
        case .count:
            EmptyView()
        case .heartRate:
            Buttons.HeartRate()
        }
    }
    
    private let spacing: CGFloat = 12
    private let cornerRadius : Int = 15
    
    var bottomInset : CGFloat {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: 0) {
            
            // Actual Assessment taking, customized to fit the given type
            VStack(spacing: spacing) {
                
                VStack(spacing: spacing) {
                    statsDisplay
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    HStack(spacing: spacing) {
                        ButtonOptions.reset.button(action: {
                            print(bottomInset)
                        })
                        
                        ButtonOptions.start.button(action: {})
                    }
                }.layoutPriority(2)
                
                buttons
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .layoutPriority(2)

            }
            .scenePadding(.horizontal)
            .scenePadding(bottomInset != 0 ? .top : .vertical)
            .layoutPriority(1)
            
            // Required to keep the navigationBar pressed against the top of the view when now buttons or stats are available to display
            Spacer(minLength: 0)
                .layoutPriority(0)
        }
        
        // Navigation Bar
        .safeAreaInset(edge: .top, spacing: 0) {
            navigationBar
                .background(.bar)
        }
        
        .background(Color(.systemGroupedBackground))
        .sheet(item: $assessmentSettingsSelection) { type in
            NavigationView {
                AssessmentOptions(type: type)
            }
        }
    }
    
    // MARK: - Navigation Bar
    var navigationBar : some View {
        VStack(spacing: 0) {
            
            HStack {
                
                AssessmentGalleryIcon(type: type)
                
                VStack(alignment: .leading) {
                    
                    Text(type.title)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(1)
                    
                    Text("53 assessments")
                        .foregroundColor(.secondary)
                        .font(.caption)
                        .lineLimit(1)
                }
                
                Spacer()
                
                HStack(spacing: 16) {
                    
                    Button {
                        assessmentSettingsSelection = type
                    } label: {
                        Label("Options", systemImage: "ellipsis.circle")
                    }
                    
                    Button {
                        dismiss()
                    } label: {
                        Label("Close", systemImage: "xmark.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .foregroundColor(.gray)
                    }
                }
                .labelStyle(.iconOnly)
                .imageScale(.large)
                .font(.title3)
                
            }.padding()
            
            Divider()
                .background(.ultraThickMaterial)
        }
        
    }
    
}

struct AssessmentTaker_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentTaker(type: .timed)
    }
}

extension AssessmentTaker {
    
    struct BuildingBlocks {
        
        struct ControlButton : View {
            var title: String
            var systemImage: String
            var color: Color
            
            var action : () -> Void
            
            var body: some View {
                Button(action: action) {
                    Label(title, systemImage: systemImage)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(color)
                .font(.title2)
            }
        }
        
    }
}


// Customized portions
extension AssessmentTaker {
    
    struct Stats {
        struct HeartRate : View {
            
            @EnvironmentObject var model : HeartRateAssessment
            
            var body: some View {
                StatsDisplay()
                    .cornerRadius(15.0)
            }
        }
    }
    
    struct Buttons {
        struct HeartRate : View {
            
            @EnvironmentObject var model : HeartRateAssessment
            
            var body: some View {
                TapButton(
                    taps: $model.taps,
                    countingState: model.countingState
                )
            }
        }
    }
}
