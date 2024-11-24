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
                    .frame(maxWidth: .infinity)
            }
        }
        .buttonStyle(.borderedProminent)
        .padding(5)
        
    }
}

#Preview {
    FilterButtonView(title: "Filter", action: {})
}
