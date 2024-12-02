//
//  AwesomeSheetView.swift
//
//  Created by Boris D. on 99.99.9999.
//

import SwiftUI

public struct UIConfiguration {
    public var itemHeight: CGFloat
    public var itemsVerticalPadding: CGFloat
    public init(
        itemHeight: CGFloat = 58.0,
        itemsVerticalPadding: CGFloat = 16.0
    ) {
        self.itemHeight = itemHeight
        self.itemsVerticalPadding = itemsVerticalPadding
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
                    titleSection
                    ScrollView {
                        contentSection
                    }
                    Spacer()
                    if let bottomContent = bottomContent {
                        bottomContent()
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
        let panSectionHeight = 16.0
        let titleSectionHeight = 62.0
        
        var screenSafeAreaDesignPadding = 180.0
        
        var designHeight = panSectionHeight + titleSectionHeight + configuration.itemsVerticalPadding
        
        if bottomContent != nil {
            let bottomContentHeight = 72.0
            designHeight += bottomContentHeight + bottomSafeAreaPadding
            screenSafeAreaDesignPadding += bottomContentHeight + bottomSafeAreaPadding
        }
        
        let itemsHeight = configuration.itemHeight * CGFloat(items.count)
        let totalHeight = designHeight + itemsHeight
        
        let maxScreenHeight = UIScreen.main.bounds.height
        let totalMaxHeight = maxScreenHeight - screenSafeAreaDesignPadding
        
        return min(totalHeight, totalMaxHeight)
    }
    
    @ViewBuilder
    private var contentSection: some View {
        VStack(spacing: configuration.itemsVerticalPadding) {
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
        configuration: UIConfiguration = .init(),
        onItemSelection: @escaping (T) -> Void,
        @ViewBuilder content: @escaping (T) -> ItemView
    ) -> some View {
        self.overlay(
            AwesomeBottomSheetView(
                isShowing: isShowing,
                title: title,
                items: items,
                onItemSelection: onItemSelection,
                content: content,
                configuration: configuration
            )
        )
    }
    
    public func awesomeSheet<ItemView: View, T: Identifiable>(
        isShowing: Binding<Bool>,
        items: [T],
        title: String,
        configuration: UIConfiguration = .init(),
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
                configuration: configuration,
                bottomContent: bottomContent
            )
        )
    }
}
