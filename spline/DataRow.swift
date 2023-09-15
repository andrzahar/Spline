import SwiftUI

struct DataRow: View {
    
    @ScaledMetric var imageWidth: CGFloat = 40
    
    let data: DataIn
    
    var body: some View {
        HStack {
            Label {
                VStack(alignment: .leading, spacing: 5) {
                    Text(data.name)
                        .fontWeight(.bold)
                }
            } icon: {
                 Image(systemName: "function")
                    .padding(.trailing, 15)
            }
        }
    }
}
