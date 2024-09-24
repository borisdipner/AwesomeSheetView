//
//  AwesomeSheetView.swift
//
//  Created by Boris on 99.99.9999.
//

import SwiftUI

struct AwesomeBottomSheetView<ItemView: View, T: Identifiable>: View {
    
    @Binding var isShowing: Bool
    var items: [T]
    var onItemSelection: (T) -> Void
    var title: String
    var content: (T) -> ItemView
    var itemHeight = 58.0
    
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
                
                VStack(spacing: .zero) {
                    panSection
                    titleSection
                    ScrollView {
                        contentSection
                    }
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: countHeight())
                .background(.white)
                .cornerRadius(16, corners: [.topLeft, .topRight])
                .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .animation(.easeInOut, value: isShowing)
    }
    
    private func countHeight() -> CGFloat {
        let panSectionHeight = 16.0
        let titleSectionHeight = 62.0
        let bottomSectionHeight = 33.0
        let itemsVerticalPadding = 16.0
        let designHeight = panSectionHeight + titleSectionHeight + bottomSectionHeight + itemsVerticalPadding
        
        let itemsHeight = itemHeight * CGFloat(items.count)
        
        let totalHeight = designHeight + itemsHeight
        
        let maxScreenHeight = UIScreen.main.bounds.height
        let screenSafeAreaDesignPadding = 180.0
        let totalMaxHeight = maxScreenHeight - screenSafeAreaDesignPadding
        
        return min(totalHeight, totalMaxHeight)
    }
    
    @ViewBuilder
    private var contentSection: some View {
        VStack(spacing: 8) {
            ForEach(items) { item in
                content(item)
                    .onTapGesture {
                        onItemSelection(item)
                    }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
    
    @ViewBuilder
    private var panSection: some View {
        HStack(spacing: .zero) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray)
                .frame(width: 36, height: 4)
                .padding(.top, 8)
        }
    }
    
    @ViewBuilder
    private var titleSection: some View {
        HStack(spacing: .zero) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 16)
        }
    }
}
