//
//  AwesomeSheetView.swift
//
//  Created by Boris D. on 99.99.9999.
//

import SwiftUI

public struct UIConfiguration {
    public var itemHeight: CGFloat
    public var itemsVerticalSpacing: CGFloat
    public init(
        itemHeight: CGFloat = 58.0,
        itemsVerticalSpacing: CGFloat = 0.0
    ) {
        self.itemHeight = itemHeight
        self.itemsVerticalSpacing = itemsVerticalSpacing
    }
}

struct AwesomeBottomSheetView<ItemView: View, T: Identifiable>: View {
    @Binding var isShowing: Bool
    var title: String
    var items: [T]
    var onItemSelection: (T) -> Void
    var content: (T) -> ItemView
    var configuration: UIConfiguration
    var bottomContent: (() -> AnyView)? = nil
    
    @State private var contentHeight: CGFloat = 0 // Сохраняем высоту содержимого

    let titleSectionHeight = 52.0
    let panSectionHeight = 16.0
    let contentTopPadding = 8.0
    let contentBottomPadding = 16.0
    let bottomContentHeight = 72.0
    
    let bottomSafeAreaPadding = 33.0
    
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
                        .frame(maxHeight: panSectionHeight)
                    titleSection
                        .frame(maxHeight: titleSectionHeight)
                    
                    // ScrollView с динамической высотой
                    ScrollView {
                        contentSection
//                            .background(
//                                GeometryReader { proxy in
//                                    Color.clear
//                                        .onAppear {
//                                            contentHeight = proxy.size.height
//                                        }
//                                        .onChange(of: items.count) { _ in
//                                            contentHeight = proxy.size.height
//                                        }
//                                }
//                            )
                    }
                    .frame(height: min(contentHeight, countHeight())) // Ограничение высоты

                    if let bottomContent = bottomContent {
                        bottomContent()
                            .frame(maxHeight: bottomContentHeight)
                            .padding(.bottom, bottomSafeAreaPadding)
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
        var screenSafeAreaDesignPadding = 180.0
        let contentPaddings = contentTopPadding + contentBottomPadding
        var designHeight = panSectionHeight + titleSectionHeight
        
      
        
        if bottomContent != nil {
            designHeight += bottomContentHeight + bottomSafeAreaPadding
            screenSafeAreaDesignPadding += bottomContentHeight + bottomSafeAreaPadding
        }
        
        let itemsHeight = configuration.itemHeight * CGFloat(items.count)
        var totalHeight = designHeight + itemsHeight
        var itemsSpacing = 0.0
        if items.count > 0 {
            itemsSpacing = configuration.itemsVerticalSpacing * CGFloat(items.count - 1)
            totalHeight += itemsSpacing
        }
        contentHeight = contentPaddings + itemsHeight + itemsSpacing
        
        let maxScreenHeight = UIScreen.main.bounds.height
        let totalMaxHeight = maxScreenHeight - screenSafeAreaDesignPadding
        
        return min(totalHeight, totalMaxHeight)
    }
    
    @ViewBuilder
    private var contentSection: some View {
        VStack(spacing: configuration.itemsVerticalSpacing) {
            ForEach(items) { item in
                content(item)
                    .onTapGesture {
                        onItemSelection(item)
                    }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, contentTopPadding)
        .padding(.bottom, contentBottomPadding)
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
