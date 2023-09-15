import SwiftUI

struct MoreInfoView: View {
    
    let calc: Calculator
    @Binding var selectedInterpolate: Int?
    
    @State private var intSelectedInterpolate: Int = 0
    @State private var rangeInterpolate: ClosedRange<Int> = 0...0
    @State private var selectionX: Int = 0
    
    private var idiom : UIUserInterfaceIdiom { UIDevice.current.userInterfaceIdiom }
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Stepper(value: $intSelectedInterpolate, in: rangeInterpolate) {
                Text("График построен с использованием \(intSelectedInterpolate) точек из \(rangeInterpolate.upperBound) точек")
                    .monospacedDigit()
            }
            .onChange(of: intSelectedInterpolate, perform: {
                selectedInterpolate = $0 - 2
            })
            
            if horizontalSizeClass == .regular {
                Spacer()
                Text("Приближение для x:")
                
                Picker("Приближение для x:", selection: $selectionX) {
                    ForEach(calc.compairing.indices) { comp in
                        Text(calc.compairing[comp].x)
                    }
                }
                .pickerStyle(.segmented)
                
                Table(calc.compairing[selectionX].rows) {
                    TableColumn("n", value: \.numberOfPoint)
                        .width(min: 10, ideal: 20, max: 30)
                    TableColumn("y", value: \.y)
                    TableColumn("delta", value: \.delta)
                }
            }
                    
            }
            .padding()
            .onAppear {
                let count = calc.interpolates.count + 1
                self.rangeInterpolate = 2...count
                
                if let selected = selectedInterpolate {
                    self.intSelectedInterpolate = selected + 2
                } else {
                    self.intSelectedInterpolate = count
                }
            }
    }
}
