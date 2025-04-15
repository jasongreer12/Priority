//
//  SideMenuRightView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct SideMenuRightView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel
    @State private var showOptionsSheet = false
    @Binding var isSideMenuOpen: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            VStack {
                
                Text("Options")
                    .font(.title)
                    .bold()
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.vertical, 1)
                
                Button(action: {
                    taskViewModel.sortMode = .custom
                    taskViewModel.sortTasks()
                    isSideMenuOpen = false
                }) {
                    Label("Sort by Custom Order", systemImage: "line.3.horizontal")
                }
                .padding()
                
                Button(action: {
                    taskViewModel.sortMode = .prioritized
                    taskViewModel.sortTasks()
                    isSideMenuOpen = false
                }) {
                    Label("Sort PRIORITIZED", systemImage: "line.3.horizontal")
                }
                .padding()
                
                Divider()
                    .padding(.vertical, 1)
                
                Button(action: {
                    showOptionsSheet = true
                }) {
                    Label("More Options", systemImage: "gearshape")
                }
                .sheet(isPresented: $showOptionsSheet) {
                    OptionsView()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                
                Spacer()
                    .foregroundColor(.red)
                    .padding(.bottom, 50)
                    .padding(.top, 20)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 250)
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
        }
    }
}

//#Preview {
//    SideMenuRightView(isSideMenuOpen: .constant(true))
//        .environmentObject(taskViewModel)
//}
