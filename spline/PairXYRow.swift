import SwiftUI

struct PairXYRow: View {
    @Binding var pairXY: PairXY
    var focusedPair: FocusState<PairXY?>.Binding
    
    var body: some View {
        HStack {
            
            TextField("x", value: $pairXY.x, format: .number)
                .focused(focusedPair, equals: pairXY)
                .keyboardType(.decimalPad)
            Spacer()
            
            TextField("y", value: $pairXY.y, format: .number)
                .keyboardType(.decimalPad)
            Spacer()
        }
    }
}
