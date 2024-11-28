//
//  AwesomeSheetView.swift
//
//  Created by Boris D. on 99.99.9999.
//

import SwiftUI

struct AwesomeBottomSheetView<ItemView: View, T: Identifiable>: View {
    @Binding var isShowing: Bool
    var title: String
    var items: [T]
    var onItemSelection: (T) -> Void
    var content: (T) -> ItemView
    var itemHeight = 58.0
    var bottomContent: (() -> AnyView)? = nil
    
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
                    if let bottomContent = bottomContent {
                        bottomContent()
                    }
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
        let itemsVerticalPadding = 16.0
        
        var designHeight = panSectionHeight + titleSectionHeight + itemsVerticalPadding
        
        if hasBottomBar {
            designHeight += 33.0 // Bottom bar height
        }
        
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

extension View {
    public func awesomeSheet<ItemView: View, T: Identifiable>(
        isShowing: Binding<Bool>,
        items: [T],
        title: String,
        onItemSelection: @escaping (T) -> Void,
        @ViewBuilder content: @escaping (T) -> ItemView
    ) -> some View {
        self.overlay(
            AwesomeBottomSheetView(
                isShowing: isShowing,
                title: title,
                items: items,
                onItemSelection: onItemSelection,
                content: content
            )
        )
    }
    
    public func awesomeSheet<ItemView: View, T: Identifiable>(
        isShowing: Binding<Bool>,
        items: [T],
        title: String,
        onItemSelection: @escaping (T) -> Void,
        @ViewBuilder content: @escaping (T) -> ItemView,
        bottomContent: @escaping () -> AnyView
    ) -> some View {
        self.overlay(
            AwesomeBottomSheetView(
                isShowing: isShowing,
                title: title,
                items: items,
                onItemSelection: onItemSelection,
                content: content,
                bottomContent: bottomContent
            )
        )
    }
}
