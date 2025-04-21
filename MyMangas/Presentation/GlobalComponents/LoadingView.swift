import SwiftUI

struct LoadingView: View {
    @Binding var loading: Bool
    
    var body: some View {
        ProgressView()
            .controlSize(.extraLarge)
            .tint(.cyan)
            .opacity(loading ? 1.0 : 0.0)
    }
}

#Preview {
    LoadingView(loading: .constant(true))
}
