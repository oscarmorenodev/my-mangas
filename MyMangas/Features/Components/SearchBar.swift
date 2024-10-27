import SwiftUI

fileprivate struct SearchBar: ViewModifier {
    let searchText: Binding<String>
    let placeholder: String
    let visible: Bool
    
    func body(content: Content) -> some View {
        if visible {
            content
                .searchable(text: searchText, prompt: placeholder)
        } else {
            content
        }
    }
}

extension View {
    func addCustomSearchBar(searchText: Binding<String>,
                            placeholder: String,
                            visible: Bool = true) -> some View {
        modifier(SearchBar(searchText: searchText,
                           placeholder: placeholder,
                           visible: visible))
    }
}
