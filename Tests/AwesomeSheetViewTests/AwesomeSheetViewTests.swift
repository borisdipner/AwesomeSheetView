//
//  AwesomeSheetViewTests.swift
//
//  Created by Boris D. on 99.99.9999.
//

import XCTest
import SwiftUI
@testable import AwesomeSheetView

final class AwesomeSheetViewTests: XCTestCase {
    
    /// Checking selecting card
    func testCardSelection() {
        // Given
        var selectedCard: Card? = nil
        let items = [Card(id: "1", name: "Card 1"), Card(id: "2", name: "Card 2")]
        
        // When
        let sheet = AwesomeBottomSheetView(
            isShowing: .constant(true),
            title: "Select a Card",
            items: items,
            onItemSelection: { card in
                selectedCard = card
            }
        ) { item in
            Text(item.name)
        }
        
        sheet.onItemSelection(items.first!)
        
        // Then
        XCTAssertEqual(selectedCard?.id, "1", "Selected card should be Card 1")
    }
}
