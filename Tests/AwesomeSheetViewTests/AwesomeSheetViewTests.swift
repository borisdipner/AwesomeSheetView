//
//  AwesomeSheetViewTests.swift
//
//  Created by Boris on 99.99.9999.
//

import XCTest
import SwiftUI
@testable import AwesomeSheetView

final class AwesomeSheetViewTests: XCTestCase {
    
    /// Checking start state of bottom sheet
    func testBottomSheetShowing() {
        // Given
        var isShowing = false
        let items = [Card(id: "1", name: "Card 1")]
        
        // When
        let sheet = AwesomeBottomSheetView(
            isShowing: .constant(isShowing),
            items: items,
            onItemSelection: { _ in },
            title: "Select a Card"
        ) { item in
            Text(item.name)
        }
        
        // Then
        XCTAssertFalse(isShowing, "Bottom sheet should not be showing initially.")
    }
    
    /// Checking selecting card
    func testCardSelection() {
        // Given
        var selectedCard: Card? = nil
        let items = [Card(id: "1", name: "Card 1"), Card(id: "2", name: "Card 2")]
        
        // When
        let sheet = AwesomeBottomSheetView(
            isShowing: .constant(true),
            items: items,
            onItemSelection: { card in
                selectedCard = card
            },
            title: "Select a Card"
        ) { item in
            Text(item.name)
        }
        
        sheet.onItemSelection(items.first!)
        
        // Then
        XCTAssertEqual(selectedCard?.id, "1", "Selected card should be Card 1")
    }
}
