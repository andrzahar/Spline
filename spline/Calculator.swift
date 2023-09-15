import Foundation

/*
 Проведение интерполирования для разного числа узлов интерполяции, хранение этих результатов 
 */
class Calculator: ObservableObject {
    
    @Published var interpolates: [Interpolate] = []
    @Published var compairing: [CompairingTable] = []
    @Published var error = false
    private var dataIn: DataIn
    
    init(dataIn: DataIn) {
        self.dataIn = dataIn
    }
    
    func calculate() {
        do {
            try unsafeCalculate()
        } catch {
            self.error = true
        }
    }
    
    private func unsafeCalculate() throws {
        let n = dataIn.table.count
        
        let findIn = dataIn.getFindIn().sorted()
        
        for x in findIn {
            compairing.append(CompairingTable(x: x.description, rows: []))
        }
        
        for i in 0...(n - 2) {
            let inter = try Interpolate(dataIn: dataIn, n: i)
            
            if inter.error {
                error = true
                return
            }
            
            func getDelta(i: Int, y: Double) -> String {
                if let last = interpolates.last {
                    return String(abs(y - last.findTables[i].y))
                } else {
                    return "-"
                }
            }
            
            for (xi, table) in inter.findTables.enumerated() {
                compairing[xi].rows.append(
                    CompairingRow(numberOfPoint: String(i + 2), y: table.y.description, delta: getDelta(i: xi, y: table.y))
                )
            }
            interpolates.append(inter)
        }
    }
}
