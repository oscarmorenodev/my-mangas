import SwiftUI

struct CategoryButtonView: View {
    let title: String
    let action: () -> Void
    
    var body: some View {
        Group {
            Button {
                action()
            } label: {
                Text(title)
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.borderedProminent)        
    }
}

#Preview {
    CategoryButtonView(title: "Filter", action: {})
}
