import SwiftUI

struct FilterButtonView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Group {
            Button {
                action()
            } label: {
                Text(title)
            }
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    FilterButtonView(title: "Filter", action: {})
}
