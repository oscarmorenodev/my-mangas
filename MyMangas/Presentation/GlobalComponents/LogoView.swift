import SwiftUI

struct LogoView: View {
    @State var width: CGFloat?
    @State var height: CGFloat?
    
    var body: some View {
        Image("MyMangasLogo")
            .resizable()
            .frame(width: width ?? 200,
                   height: height ?? 140)
            .cornerRadius(20)
            .padding(.vertical, 25)
    }
}

#Preview {
    LogoView()
}
