import SwiftUI
import Charts

/*
 Хранение входного набора данных
 */
struct DataIn: Identifiable, Codable, Hashable {
    @CodableKey
    var id: UUID
    var name: String
    var boundaryConditions: BoundaryConditions
    var findIn: [FindIn]
    var table: [PairXY]
}

/*
 Граничные условия
 */
struct BoundaryConditions: Codable, Hashable {
    var a: Double
    var b: Double
}

/*
 Пара значений x и y 
 */
struct PairXY: Identifiable, Codable, Hashable {
    @CodableKey
    var id: UUID
    var x: Double
    var y: Double
}

struct FindIn: Identifiable, Codable, Hashable {
    @CodableKey
    var id: UUID
    var value: Double
}

extension DataIn {
    func getFindIn() -> [Double] {
        return findIn.map { $0.value }
    }
}

extension PairXY {
    
    func toScreen(xAccuracy: Int) -> String {
        return "\(String(format: "x: %.\(xAccuracy)f", x))\ny: \(y.description)"
    }
    
    func getAnnotationPosition(allTable: [PairXY]) -> AnnotationPosition {
        let range = allTable.xRange()
        let average = (abs(range.upperBound) + abs(range.lowerBound)) / 2.0
        let four = average / 2.0
        if range.lowerBound + four > x {
            return .topTrailing
        } else if range.upperBound - four < x {
            return .topLeading
        } else {
            return .top
        }
    }
}

extension [PairXY] {
    
    func xRange() -> ClosedRange<Double> {
        return first!.x...last!.x
    }
    
    func yRange() -> ClosedRange<Double> {
        let sotedByY = sorted(by: { $0.y < $1.y })
        var first = sotedByY.first!.y
        var last = sotedByY.last!.y
        if abs(last - first) < 0.00000000000001 {
            first -= 5
            last += 5
        }
        return first...last
    }
}
