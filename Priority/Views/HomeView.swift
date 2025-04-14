//
//  HomeView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Priority")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            ProgressRingView(progress: taskViewModel.completionPercentage)
                .frame(width: UIScreen.main.bounds.height * 0.25,
                       height: UIScreen.main.bounds.height * 0.25)
                .padding(.top, 10)
                        
            if !taskViewModel.tasks.isEmpty {
                TaskListView()
                    .frame(width: UIScreen.main.bounds.width - 40,
                           height: UIScreen.main.bounds.width - 40)
                    .cornerRadius(16)
                    .padding(.top, 36)
                    .padding(.horizontal, 20)
            }
        }
        .padding(.bottom, 21)
        .onAppear {
            taskViewModel.fetchTasks(context: TaskManager.shared.viewContext)
        }
    }
}

struct ProfileHeader: View {
    @State var picture: String
    
    private let size: CGFloat = 100
    
    var body: some View {
#if os(iOS)
        AsyncImage(url: URL(string: picture), content: { image in
            image.resizable()
        }, placeholder: {
            Color.clear
        })
        .frame(width: self.size, height: self.size)
        .clipShape(Circle())
        .padding(.bottom, 24)
#else
        Text("Profile")
#endif
    }
}

struct ProfileCell: View {
    @State var key: String
    @State var value: String
    
    private let size: CGFloat = 14
    
    var body: some View {
        HStack {
            Text(key)
                .font(.system(size: self.size, weight: .semibold))
            Spacer()
            Text(value)
                .font(.system(size: self.size, weight: .regular))
#if os(iOS)
                .foregroundColor(Color("Grey"))
#endif
        }
#if os(iOS)
        .listRowBackground(Color.white)
#endif
    }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//            .environmentObject(TaskViewModel())
//    }
//}
