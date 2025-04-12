//
//  ProgressRingView.swift
//  Priority-redo
//
//  Created by Alex on 3/7/25.
//

import SwiftUI

struct ProgressRingView: View {
    //var progress: Double  // Expected value between 0 and 1
    @State private var animatedProgress: Double = 0
    
    @FetchRequest(fetchRequest: Task.all()) private var tasks
    var completionPercentage: Double {
        if tasks.isEmpty {
            return 1.0
        } else {
            let completedCount = tasks.filter { $0.isComplete }.count
            return Double(completedCount) / Double(tasks.count)
        }
    }
    
    //@FetchRequest(fetchRequest: Task.all()) private var tasks
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(Color.gray.opacity(0.2))
            
            // Animated progress circle.
            Circle()
                .trim(from: 0, to: CGFloat(animatedProgress))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(progressRingColor(for: animatedProgress))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: animatedProgress)
            
            // Large percentage text inside the circle.
            Text("\(Int(animatedProgress * 100))%")
                .font(.system(size: 30, weight: .bold))
        }
        .onAppear {
            animatedProgress = completionPercentage
        }
        .onChange(of: completionPercentage) { newValue, _ in
            withAnimation(.easeInOut(duration: 1)) {
                animatedProgress = newValue
            }
        }
    }
    
    private func progressRingColor(for progress: Double) -> Color {
        if progress < 0.33 {
            return .red
        } else if progress < 0.66 {
            return .orange
        } else {
            return .green
        }
    }
}

struct ProgressRingView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRingView()
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
