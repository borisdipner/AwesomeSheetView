//
//  BottomSheetSize.swift
//  AwesomeSheetView
//
//  Created by Boris on 02.12.2024.
//

import SwiftUI

enum BottomSheetSize {
    case half
    case full
    case custom(CGFloat)
}

struct AwesomeBottomContentSheetView<Content: View>: View {
    @Binding var isShowing: Bool
    var title: String?
    var size: BottomSheetSize
    var content: () -> Content
    
    var body: some View {
        ZStack(alignment: .bottom) {
            if isShowing {
                BlurView(style: .systemUltraThinMaterial)
                    .ignoresSafeArea()
                
                Color.black
                    .opacity(0.2)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isShowing = false
                        }
                    }
                
                VStack(spacing: 0) {
                    panSection
                    if let title = title {
                        titleSection(title: title)
                    }
                    content()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: calculateHeight())
                .background(Color.white)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .transition(.move(edge: .bottom))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
    
    private func calculateHeight() -> CGFloat {
        let screenHeight = UIScreen.main.bounds.height
        switch size {
        case .half:
            return ( screenHeight / 2 ) + 100
        case .full:
            return screenHeight - 120
        case .custom(let height):
            return min(height, screenHeight - 100)
        }
    }
    
    @ViewBuilder
    private var panSection: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray)
                .frame(width: 36, height: 4)
                .padding(.top, 8)
        }
    }
    
    @ViewBuilder
    private func titleSection(title: String) -> some View {
        HStack {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 16)
        }
    }
}

extension View {
    func awesomeContentSheet<Content: View>(
        isShowing: Binding<Bool>,
        title: String? = nil,
        size: BottomSheetSize = .half,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        self.overlay(
            AwesomeBottomContentSheetView(
                isShowing: isShowing,
                title: title,
                size: size,
                content: content
            )
        )
    }
}
