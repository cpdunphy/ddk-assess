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
    var controlButtons : some View {
        switch type {
        case .timed:
            EmptyView()
        case .count:
            EmptyView()
        case .heartRate:
            ControlButtons.HeartRate()
        }
    }
    
    @ViewBuilder
    var tapButtons : some View {
        switch type {
        case .timed:
            EmptyView()
        case .count:
            EmptyView()
        case .heartRate:
            TapButtons.HeartRate()
        }
    }
    
    private let spacing: CGFloat = 12
    private let cornerRadius : Int = 15
    
    // MARK: - Body
    var body: some View {
        
        GeometryReader { geo in
            
            VStack(spacing: 0) {
                
                // Actual Assessment taking, customized to fit the given type
                VStack(spacing: spacing) {
                    
                    VStack(spacing: spacing) {
                        statsDisplay
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        HStack(spacing: spacing) {
                            controlButtons
                        }
                    }.layoutPriority(2)
                    
                    tapButtons
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .layoutPriority(2)
                    
                }
                .scenePadding(.horizontal)
                .scenePadding(geo.safeAreaInsets.bottom != 0 ? .top : .vertical)
                .layoutPriority(1)
                
                
                // Required to keep the navigationBar pressed against the top of the view when now buttons or stats are available to display
                Spacer(minLength: 0)
                    .layoutPriority(0)
                
            }
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
}

struct AssessmentTaker_Previews: PreviewProvider {
    static var previews: some View {
        AssessmentTaker(type: .timed)
    }
}

// MARK: - Navigation Bar
extension AssessmentTaker {
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

// MARK: Building Blocks
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
                        .lineLimit(2)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .tint(color)
                .font(.title2)
            }
        }
        
        
        struct TitleFont: ViewModifier {
            @ScaledMetric(relativeTo: .largeTitle) var titleFontSize: CGFloat = 48
            
            func body(content: Content) -> some View {
                return content.font(.system(size: titleFontSize, weight: .bold, design: .rounded).monospacedDigit())
            }
        }
        
        struct SubtitleFont: ViewModifier {
            @ScaledMetric(relativeTo: .largeTitle) var subtitleFontSize: CGFloat = 24
            
            func body(content: Content) -> some View {
                return content
                    .font(Font.system(size: subtitleFontSize, weight: .regular, design: .rounded).monospacedDigit())
            }
        }
        
        struct Separator : View {
            
            var width : CGFloat = 95
            
            var body: some View {
                RoundedRectangle(cornerRadius: 100.0)
                    .foregroundColor(.secondary)
                    .frame(width: width, height: 4)
                    .padding(.vertical, 10)
            }
        }
    }
}

//@available(iOS 13, macCatalyst 13, tvOS 13, watchOS 6, *)
//extension View {
//    func scaledFont(name: String, size: CGFloat) -> some View {
//        return self.modifier(ScaledFont(name: name, size: size))
//    }
//}


// MARK: Customized portions
extension AssessmentTaker {
    
    // MARK: Stats
    struct Stats {
        struct HeartRate : View {
            
            @EnvironmentObject var model : HeartRateAssessment
            
            @ScaledMetric(relativeTo: .largeTitle) var titleFontSize: CGFloat = 48
            @ScaledMetric(relativeTo: .headline) var subtitleFontSize: CGFloat = 24
            
            
            var body: some View {
                GeometryReader { geo in
                    VStack(spacing: 0) {
                        
                        Text("00:07.5")
                            .modifier(BuildingBlocks.TitleFont())
                        
                        BuildingBlocks.Separator()

                        Text("12 taps")
                            .modifier(BuildingBlocks.SubtitleFont())
                        
                    }.position(x: geo.size.width / 2, y: geo.size.height / 2)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.secondarySystemGroupedBackground))
                .cornerRadius(15.0)
        }
    }
}

// MARK: Controls
struct ControlButtons {
    struct HeartRate : View {
        var body: some View {
            ButtonOptions.reset.button(action: {})
            
            ButtonOptions.start.button(action: {})
        }
    }
}

// MARK: Taps
struct TapButtons {
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
