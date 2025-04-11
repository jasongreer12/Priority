//
//  WidgetRingView.swift
//  PriorityWidgetExtension
//
//  Created by Alex on 4/10/25.
//

import Foundation
import SwiftUI

struct ProgressRingView: View {
    var progress: Double  // Expected value between 0 and 1
    @State private var animatedProgress: Double = 0
    
    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(lineWidth: 10)
                .foregroundColor(Color.gray.opacity(0.2))
            
            // Animated progress circle.
            Circle()
                .trim(from: 0, to: CGFloat(animatedProgress))
                .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .foregroundColor(progressRingColor(for: animatedProgress))
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: animatedProgress)
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { newValue, _ in
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
