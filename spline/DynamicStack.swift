import SwiftUI

struct DynamicStack<Content: View>: View {
    
    var horizontalAlignment = HorizontalAlignment.center
    var verticalAlignment = VerticalAlignment.center
    var spacing: CGFloat?
    
    @ViewBuilder var content: () -> Content

    var body: some View {
        GeometryReader { proxy in
            Group {
                if proxy.size.width > proxy.size.height {
                    HStack(
                        alignment: verticalAlignment,
                        spacing: spacing,
                        content: content
                    )
                } else {
                    VStack(
                        alignment: horizontalAlignment,
                        spacing: spacing,
                        content: content
                    )
                }
            }
        }
    }
}
