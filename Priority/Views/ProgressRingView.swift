//
//  ProgressRingView.swift
//  Priority
//
//  Created by Alex on 3/7/25.
//
import SwiftUI

struct ProgressRingView: View {
    var progress: Double
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(Color.gray.opacity(0.2))
            
            Circle()
                .trim(from: 0, to: CGFloat(animatedProgress))
                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round))
                .foregroundColor(progressRingColor(for: animatedProgress))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: animatedProgress)
            
            Text("\(Int(animatedProgress * 100))%")
                .font(.system(size: 30, weight: .bold))
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) {
            withAnimation {
                animatedProgress = progress
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
        ProgressRingView(progress: 0.75)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
