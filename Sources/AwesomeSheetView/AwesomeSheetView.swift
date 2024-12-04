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
                        .frame(height: panSectionHeight)
                    titleSection
                        .frame(maxHeight: titleSectionHeight)
                    ScrollView {
                        contentSection
                    }
                    .frame(height: countContentHeight())
                    .padding(.top, contentTopPadding)
                    .padding(.bottom, contentBottomPadding)
                    if let bottomContent = bottomContent {
                        bottomContent()
                            .frame(height: bottomContentHeight)
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
    
    private func countContentHeight() -> CGFloat {
        let itemsHeight = configuration.itemHeight * CGFloat(items.count)
       
        if !items.isEmpty {
            let itemsSpacing = configuration.itemsVerticalSpacing * CGFloat(items.count - 1)
            return itemsHeight + itemsSpacing
        } else {
            return itemsHeight
        }
    }
    
    private func countHeight() -> CGFloat {
        var screenSafeAreaDesignPadding = 180.0
        var bottomSheetFullHeight = 0.0
        
        // PanSection
        bottomSheetFullHeight += panSectionHeight
        // TitleSection
        bottomSheetFullHeight += titleSectionHeight
        // ContentSection
        var contentFullHeight = 0.0
        let contentPaddings = contentTopPadding + contentBottomPadding
        let contentHeight = configuration.itemHeight * CGFloat(items.count)
        var contentSpacings = 0.0
        if !items.isEmpty {
            contentSpacings = configuration.itemsVerticalSpacing * CGFloat(items.count - 1)
        }
        contentFullHeight = contentPaddings + contentHeight + contentSpacings
        bottomSheetFullHeight += contentFullHeight
        // BottomSection
        var bottomSectionHeight = 0.0
        if bottomContent != nil {
            bottomSectionHeight = bottomContentHeight + bottomSafeAreaPadding
            screenSafeAreaDesignPadding += bottomContentHeight + bottomSafeAreaPadding
        }
        bottomSheetFullHeight += bottomSectionHeight
       
        let maxScreenHeight = UIScreen.main.bounds.height
        let totalMaxHeight = maxScreenHeight - screenSafeAreaDesignPadding
        return min(bottomSheetFullHeight, totalMaxHeight)
    }
    
    @ViewBuilder
    private var contentSection: some View {
        VStack(spacing: configuration.itemsVerticalSpacing) {
            ForEach(items) { item in
                content(item)
                    .frame(maxHeight: configuration.itemHeight)
                    .onTapGesture {
                        onItemSelection(item)
                    }
            }
        }
        .padding(.horizontal, 16)
    }
    
    @ViewBuilder
    private var panSection: some View {
        HStack(spacing: .zero) {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray)
                .frame(width: 36, height: 4)
                .padding(.top, 8)
                .padding(.bottom, 4)
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
