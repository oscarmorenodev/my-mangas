import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "book")
                .resizable()
                .scaledToFit()
                .frame(width: 50)
                .fontWeight(.semibold)
                .foregroundStyle(.tint)
                .padding()
            Text("Welcome to MyMangas App!")
                .font(.title2)
                .fontWeight(.semibold)
                .fontDesign(.rounded)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
