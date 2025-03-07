import SwiftUI

struct SideMenuRightView: View {
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
                
                Button("Option 1") {
                    isSideMenuOpen = false
                }
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.vertical, 1)
                
                Button(action: {
                    showOptionsSheet = true
                }) {
                    Label("Options", systemImage: "gearshape")
                }
                .sheet(isPresented: $showOptionsSheet) {
                    OptionsView()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                
                Divider()
                    .padding(.vertical, 1)
                
                Spacer()
                
                Divider()
                    .padding(.vertical, 1)
                
                Button("Sign Out") {
                    isSideMenuOpen = false
                }
                
                Divider()
                    .padding(.vertical, 1)
            
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
