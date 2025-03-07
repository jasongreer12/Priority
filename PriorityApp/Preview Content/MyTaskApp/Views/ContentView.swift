import SwiftUI

struct ContentView: View {
    @State private var isLeftSideMenuOpen = false
    @State private var isRightSideMenuOpen = false
    @State private var showAddTaskSheet = false


    var bottomMenuWidth: CGFloat {
        return UIScreen.main.bounds.width - 20
    }
    
    var body: some View {
        ZStack {
            HomeView()
            
            // Bottom menu overlay pinned to the bottom.
            VStack {
                Spacer()
                HStack {
                    // Left button: toggles left side menu.
                    Button(action: {
                        withAnimation {
                            isLeftSideMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "line.horizontal.3")
                            .font(.title)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Plus button: opens the Add Task sheet.
                    Button(action: {
                        showAddTaskSheet = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 40))
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Right button: toggles right side menu.
                    Button(action: {
                        withAnimation {
                            isRightSideMenuOpen.toggle()
                        }
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.title)
                            .padding()
                    }
                    .frame(maxWidth: .infinity)
                }
                .frame(width: bottomMenuWidth, height: 65)
                .background(
                    Color(UIColor.systemBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .gray.opacity(0.4), radius: 4, x: 0, y: -2)
                )
                .padding(.bottom, 30)
                .zIndex(1)
            }
            
            // Left side menu overlay.
            if isLeftSideMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { isLeftSideMenuOpen = false }
                    }
                SideMenuView(isSideMenuOpen: $isLeftSideMenuOpen)
                    .transition(.move(edge: .leading))
                    .zIndex(2)
            }
            
            // Right side menu overlay.
            if isRightSideMenuOpen {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation { isRightSideMenuOpen = false }
                    }
                SideMenuRightView(isSideMenuOpen: $isRightSideMenuOpen)
                    .transition(.move(edge: .trailing))
                    .zIndex(2)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddTaskSheet) {
            AddTaskView()
                .presentationDetents([.fraction(0.75)])
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TaskViewModel())
    }
}
