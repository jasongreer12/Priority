import SwiftUI

struct HomeView: View {
    @EnvironmentObject var taskViewModel: TaskViewModel

    var body: some View {
        VStack(spacing: 20) {
            Text("Priority")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            // Passing the computed progress value and forcing re-render with .id
            ProgressRingView(progress: taskViewModel.completionPercentage)
                .id(taskViewModel.completionPercentage)
                .frame(width: UIScreen.main.bounds.height * 0.25,
                       height: UIScreen.main.bounds.height * 0.25)
                .padding(.top, 10)
            
            Spacer()
            
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
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environmentObject(TaskViewModel())
    }
}
