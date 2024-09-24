# AwesomeSheetView

[![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)](https://github.com/yourusername/AwesomeSheetView/releases)
[![iOS](https://img.shields.io/badge/iOS-15%2B-green.svg)](https://github.com/yourusername/AwesomeSheetView)
[![Swift](https://img.shields.io/badge/Swift-5.7-orange.svg)](https://swift.org)

## Overview

`AwesomeSheetView` is a reusable and highly customizable bottom sheet component built with SwiftUI. This package allows you to present dynamic, scrollable content in a modal-like view from the bottom of the screen. It's perfect for selecting items, showing details, or any type of temporary interface.

## Features

- 🛠️ **Fully customizable**: Configure title, content, and actions.
- 🧑‍💻 **Generic implementation**: Can be used with any data model conforming to `Identifiable`.
- 🎨 **Beautiful animations**: Built-in smooth animations for presentation and dismissal.
- 📱 **iOS 15+ support**: Leverages the latest SwiftUI features and modifiers.

## Installation

### Swift Package Manager

To integrate `AwesomeSheetView` into your project, use Swift Package Manager (SPM):

1. Open your project in Xcode.
2. Navigate to `File > Swift Packages > Add Package Dependency`.
3. Enter the following URL:

```
https://github.com/yourusername/AwesomeSheetView.git
```

4. Choose the version you want to install (recommended: `1.0.0` or later).
5. Click next and finish the setup.

### Manual

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/AwesomeSheetView.git
    ```
2. Drag and drop the `AwesomeSheetView` folder into your Xcode project.

## Usage

To use `AwesomeSheetView` in your project, simply import it and provide the necessary bindings and content.

### Basic Example

```swift
import AwesomeSheetView
import SwiftUI

struct ContentView: View {
    @State private var isSheetShowing = false
    let items = [Card(id: "1", name: "Card 1"), Card(id: "2", name: "Card 2")]

    var body: some View {
        VStack {
            Button("Show Bottom Sheet") {
                isSheetShowing = true
            }
        }
        .awesomeSheet(
            isShowing: $isSheetShowing,
            items: items,
            title: "Select a Card",
            onItemSelection: { card in
                print("Selected card: \(card.name)")
            },
            content: { card in
                Text(card.name)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
            }
        )
    }
}
```

### Customizing the View

You can easily customize the content and behavior of the sheet:

- **Title**: Customize the title of the bottom sheet using the `title` parameter.
- **Content**: Pass any view to display as a row in the bottom sheet.
- **On Item Selection**: Use the `onItemSelection` closure to handle interactions when an item is selected.

### Example with Custom View

```swift
struct CustomSheetExample: View {
    @State private var isSheetShowing = false
    let items = [Product(id: "1", title: "Product 1", price: "$10"), Product(id: "2", title: "Product 2", price: "$20")]

    var body: some View {
        VStack {
            Button("Show Product Sheet") {
                isSheetShowing = true
            }
        }
        .awesomeSheet(
            isShowing: $isSheetShowing,
            items: items,
            title: "Available Products",
            onItemSelection: { product in
                print("Selected product: \(product.title)")
            },
            content: { product in
                VStack(alignment: .leading) {
                    Text(product.title)
                        .font(.headline)
                    Text(product.price)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
            }
        )
    }
}
```

## Requirements

- **iOS 15.0+**
- **Swift 5.7+**
- **Xcode 13.0+**

## Versioning

We follow [Semantic Versioning](https://semver.org/) for this package. Here’s the current version:

- `1.0.0`: Initial release with basic bottom sheet functionality.

You can check the [releases page](https://github.com/yourusername/AwesomeSheetView/releases) for updates.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Feel free to contribute, report bugs, or suggest features via GitHub Issues.

```
