import SwiftUI

struct SideMenuView: View {
    @Binding var isSideMenuOpen: Bool
    
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
                }
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.vertical, 1)
                
                Button("Option 2") {
                    isSideMenuOpen = false
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
