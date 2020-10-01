//
//  AppMobileNavigation.swift
//  Diadochokinetic Assess
//
//  Created by Collin Dunphy on 9/24/20.
//

import SwiftUI
import Combine

struct AppMobileNavigation: View {

    @EnvironmentObject var model : DDKModel
    @Environment(\.presentationMode) var presenationMode

    @State private var historyModalState : Bool = false
    @Binding var mobiletabSelection : NavigationItem
    
    
    var body: some View {
        TabView(selection: $mobiletabSelection) {
            NavigationView {
                view
            }
            .tabItem { NavigationItem.assess.label }
            .tag(NavigationItem.assess)
            
            NavigationView {
                RecordHistoryList()
            }
            .tabItem { NavigationItem.history.label }
            .tag(NavigationItem.history)
//            
//            NavigationView {
//                SupportTheDev()
//            }
//            .tabItem { NavigationItem.support.label }
//            .tag(NavigationItem.support)
            
            NavigationView {
                Settings()
            }
            .tabItem { NavigationItem.settings.label }
            .tag(NavigationItem.settings)
        }

    }

    var view : some View {
        AssessScreen()
            .background(
                Color(.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
            )
            .toolbar {
                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                    AssessmentPicker(type: $model.assessType)
                }
            }
//            .navigationBarItems(leading:
//                HStack(spacing: 16) {
//                    NavigationLink(destination: RecordHistoryList()) {
//                        Image(systemName: "tray.full.fill")
//                    }
//                    NavigationLink(destination: SupportTheDev()) {
//                        Image(systemName: "heart.fill")
//                    }
//                    NavigationLink(destination: Settings()) {
//                        Image(systemName: "gearshape.fill")
//                    }
//                }
//            )
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $historyModalState, content: {
                NavigationView {
                    RecordHistoryList()
                        .toolbar {
                            ToolbarItem(placement: ToolbarItemPlacement.navigationBarLeading) {
                                Button(action: {
                                    
                                }, label: {
                                    Label("Rate", systemImage: "heart.fill")
                                })
                            }
                            
//                                ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
//                                    Button(action: {
//
//                                    }, label: {
//                                        Label("Settings", systemImage: "gearshape.fill")
//                                    })
//                                }
                            ToolbarItem(placement: ToolbarItemPlacement.navigationBarTrailing) {
                                Button("Done") {
                                    historyModalState = false
                                }
                            }
                        }
                }
            })
    }
}

struct AssessScreen : View {
    @EnvironmentObject var model : DDKModel
    @EnvironmentObject var timerSession : TimerSession
    @State private var date = Date()
    @State private var timer : AnyCancellable?
    

    var body : some View {
        VStack(spacing: 20) {

            StatsDisplay()
            .layoutPriority(1)
            
//            HStack {
//                Button(action: {
//                    if model.assessType == .timed {
//                        
//                    } else {
//                        model.resetCount()
//                    }
//                }) {
//                    Circle()
//                        .foregroundColor(.red)
//                        .frame(width: 90, height: 90)
//                }.buttonStyle(PlainButtonStyle())
//                
//                Spacer()
//                
//                Button("Clear") {
//                    clearCurrentTime()
//                }
//                
//                Spacer()
//                
//                Button(action: {
//                    if model.assessType == .count {
//                        model.logCount()
//                    }
//                }) {
//                    Circle()
//                        .foregroundColor(.green)
//                        .frame(width: 90, height: 90)
//                }.buttonStyle(PlainButtonStyle())
//            }
//            .layoutPriority(0)
            
            TapButton()
                .layoutPriority(1)

        }
        .padding(.horizontal, 20)
        .padding([.top, .bottom], 20)

    }
    

    
    func clearCurrentTime() {
        switch model.assessType {
        case .timed:
            model.latestTimedDateRef = Date()
        case .count:
            model.latestCountDateRef = Date()
        }
    }
    
}



