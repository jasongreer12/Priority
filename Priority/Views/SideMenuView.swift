//
//  SideMenuView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct SideMenuView: View {
    @Binding var isSideMenuOpen: Bool
    var onProfileTap: (() -> Void)?
    var onCalendarTap: (() -> Void)?
    
    var body: some View {
        HStack(spacing: 0) {
            VStack {
            
                Text("Navigation")
                    .font(.title)
                    .bold()
                    .padding(.top, 100)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.vertical, 1)
                
                Button("Calender") {
                    isSideMenuOpen = false
                    onCalendarTap?()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.vertical, 1)
                
                Button("Profile") {
                                    isSideMenuOpen = false
                                    onProfileTap?()  // trigger the profile view
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.vertical, 1)
                
                Spacer()
                
            }
            .frame(width: 250)
            .background(Color(UIColor.systemBackground))
            .edgesIgnoringSafeArea(.all)
            
            Spacer()
        }
    }
}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView(isSideMenuOpen: .constant(true),
                     onProfileTap: { print("Profile tapped") },
                     onCalendarTap: { print("Calendar tapped") })
    }
}
