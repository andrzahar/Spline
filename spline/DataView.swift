import SwiftUI

struct DataView: View {
    
    let data: DataIn
    @EnvironmentObject var calc: Calculator
    
    @State private var currentPoint: PairXY?
    @Binding var showMoreInfo: Bool
    var isPresented: Bool
    
    @State private var selectedInterpolate: Int?
    
    var body: some View {
        if isPresented {
            DynamicStack {
                if !calc.interpolates.isEmpty && !calc.error {
                    ChartView(
                        currentPoint: $currentPoint,
                        showMoreInfo: $showMoreInfo,
                        interpolate: selectedInterpolate != nil ? calc.interpolates[selectedInterpolate!] : calc.interpolates.last!
                    )
                    if (showMoreInfo) {
                        Divider()
                        MoreInfoView(
                            calc: calc,
                            selectedInterpolate: $selectedInterpolate
                        )
                    }
                }
                if calc.error {
                    ZStack {
                        Text("Произошла ошибка во время выполнения вычеслений для введённых данных. Проверьте их правильность. Убедитесь, что аргументы искомых значений функции лежат в интервале аргументов интерполируемых точек.")
                    }
                }
            }
            .onAppear {
                if (calc.interpolates.isEmpty) {
                    calc.calculate()
                }
            }
        }
    }
    
    
}

/*struct DataView_Previews: PreviewProvider {
    static var previews: some View {
        let data = DataProvider.createExample()
        return DataView(
            data: data,
            calc: Calculator(dataIn: data)
        )
    }
}*/
