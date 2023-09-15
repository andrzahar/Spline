import Foundation

/*
 Составление интерполирующей функции для входного набора узлов интерполяции, определение значений функции в искомых точках 
 */
class Interpolate {
    
    var resTables: [PairXY] = []
    var findTables: [PairXY] = []
    var allPoints: [PairXY] = []
    var error = false
    
    var accuracyLenth: Int = 0
    
    private let boundaryConditions: BoundaryConditions
    private let findIn: [Double]
    var table: [PairXY]
    
    private let pointsNumber = 100
    
    init(dataIn: DataIn, n: Int) throws {
        self.boundaryConditions = dataIn.boundaryConditions
        self.findIn = dataIn.getFindIn()
        self.table = [dataIn.table.first!]
        if n > 0 {
            for i in 1...n {
                self.table.append(dataIn.table[i])
            }
        }
        self.table.append(dataIn.table.last!)
        try calculate()
    }
    
    private func calculate() throws {
        
        let sortedTable = table.sorted(by: { $0.x < $1.x } )
        let xs = sortedTable.map { $0.x }
        let ys = sortedTable.map { $0.y }
        let n = xs.count
        
        let h = Array<Double>.create(n - 1) { i in
            xs[i + 1] - xs[i]
        }
        
        let sigma = Array<Double>.create(n - 2) { i in
            ((-h[i + 1] / 3.0) + (h[i] / 3.0)) / 2.0
        }
        
        let A = Array<Double>.create(n - 2) { i in
            (-2 / h[i]) + sigma[i] * (6 / h[i].power(2))
        }
        
        let B = Array<Double>.create(n - 2) { i in
            let s1 = sigma[i] * (6 / h[i].power(2))
            let s2 = sigma[i] * (6 / h[i + 1].power(2))
            return (-4 / h[i + 1]) - (4 / h[i]) - s2 + s1
        }
        
        let C = Array<Double>.create(n - 2) { i in
            (-2 / h[i + 1]) - sigma[i] * (6 / h[i + 1].power(2))
        }
        
        let D = Array<Double>.create(n - 2) { i in
            (-6 / h[i + 1]) - sigma[i] * (12 / h[i + 1].power(2))
        }
        
        let E = Array<Double>.create(n - 2) { i in
            (-6 / h[i]) - sigma[i] * (12 / h[i].power(2))
        }
        
        var alphaLast = 0.0
        let alpha = Array<Double>.create(n - 1) { i in
            if (i != 0) {
                alphaLast = -C[i - 1] / (A[i - 1] * alphaLast + B[i - 1])
            }
            return alphaLast
        }
        
        var betaLast = boundaryConditions.a
        let beta = Array<Double>.create(n - 1) { i in
            if (i != 0) {
                let s1 = (A[i - 1] * alpha[i - 1] + B[i - 1])
                let s2 = D[i - 1] * (ys[i + 1] - ys[i])
                let s3 = E[i - 1] * (ys[i] - ys[i - 1]) / h[i - 1]
                betaLast =
                ((s2 / h[i] + s3) - A[i - 1] * betaLast) / s1
            }
            return betaLast
        }
        
        var mLast = boundaryConditions.b
        var m = Array<Double>.create(n) { it in
            let i = n - it - 1
            if (it != 0) {
                mLast = alpha[i] * mLast + beta[i]
            }
            return mLast
        }
        m.reverse()
        
        let xStart = xs.first!
        let xLast = xs.last!
        
        let accuracy = abs(xLast - xStart) / Double(pointsNumber)
        
        let accuracySecondPart = accuracy.description.split(separator: ".")[1]
        if let index = accuracySecondPart.index(of: "000000") ?? accuracySecondPart.index(of: "999999") {
            accuracyLenth = accuracySecondPart[..<index].count
        } else {
            accuracyLenth = accuracySecondPart.count
        }
        
        var i = 0
        
        func f(x: Double, i _i: Int = -1) -> PairXY? {
            
            var i = _i
            
            if (i == -1) {
                i = 0
                while !(xs[i]...xs[i + 1] ~= x) {
                    i += 1
                    if i + 1 == n {
                        return nil
                    }
                }
            }
            
            let t = (x - xs[i]) / h[i]
            
            let s1 = 1 - 3 * t.power(2) + 2 * t.power(3)
            let s2 = 3 * t.power(2) - 2 * t.power(3)
            let s31 = 1 - 2 * t + t.power(2)
            let s3 = m[i] * h[i] * t * s31
            let s41 = t.power(2) * (t - 1)
            let s4 = m[i + 1] * h[i] * s41
            
            let Sc = ys[i] * s1 + ys[i + 1] * s2 + s3 + s4
            
            return PairXY(x: x, y: Sc)
        }
        
        if xStart == xLast {
            error = true
            return
        }
        
        for xInter in stride(from: xStart, through: xLast, by: accuracy) {
            
            if xInter > xs[i + 1] {
                i += 1
            } 
            
            if let res = f(x: xInter, i: i) {
                resTables.append(res)
            }
        }
        
        resTables.append(table.last!)
        
        for x in findIn {
            if let res = f(x: x) {
                findTables.append(res)
            } else {
                error = true
                return
            }
        }
        
        allPoints = (table + findTables).sorted(by: {$0.x < $1.x})
    }
}
