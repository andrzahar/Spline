import SwiftUI
import Charts

struct ChartView: View {
    
    @Binding var currentPoint: PairXY?
    @Binding var showMoreInfo: Bool
    
    var interpolate: Interpolate
    
    var body: some View {
        VStack {
            Chart {
                TableView(isLine: false, description: "Узлы интерполяции", tables: interpolate.table)
                TableView(isLine: true, description: "Интерполирующая функция", tables: interpolate.resTables)
                TableView(isLine: false, description: "Искомые точки", tables: interpolate.findTables)
                
                if currentPoint != nil {
                    RuleMark(x: .value("Точка", currentPoint!.x))
                        .annotation(position: currentPoint!.getAnnotationPosition(allTable: interpolate.resTables)) {
                            VStack(alignment: .center, spacing: 6){
                                Text(currentPoint!.toScreen(xAccuracy: interpolate.accuracyLenth))
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background {
                                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                                            .fill(.background.shadow(.drop(radius: 2)))
                                    }
                            }
                        }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle().fill(.clear).contentShape(Rectangle())
                        .onTapGesture { location in
                            let currentId = currentPoint?.id
                            setCurrentPoint(proxy: proxy, location: location, points: interpolate.allPoints)
                            if currentId == currentPoint?.id {
                                currentPoint = nil
                            }
                        }
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    let location = value.location
                                    setCurrentPoint(proxy: proxy, location: location, points: interpolate.resTables)
                                }
                                .onEnded{ _ in
                                    currentPoint = nil
                                }
                        )
                }
            }
            .chartXScale(domain: interpolate.resTables.xRange())
            .chartYScale(domain: interpolate.resTables.yRange())
            .padding()
            
            HStack {
                Spacer()
                Button(action: {
                    showMoreInfo.toggle()
                }, label: {
                    Image(systemName: "info.circle")
                })
                .padding(.trailing)
                .padding(.bottom)
            }
        }
    }
    
    @ChartContentBuilder
    private func TableView(isLine: Bool, description: String, tables: [PairXY]) -> some ChartContent {
        ForEach(tables) { table in
            LineOrPoint(description: description, x: table.x, y: table.y, isLine: isLine)
            /*.annotation {
             Text("\(table.y)")
             .font(.caption)
             }*/
                .foregroundStyle(by: .value(description, description))
        }
    }
    
    @ChartContentBuilder
    private func LineOrPoint(description: String, x: Double, y: Double, isLine: Bool) -> some ChartContent {
        if isLine {
            LineMark(
                x: .value(description, x),
                y: .value(description, y)
            )
        } else {
            PointMark(
                x: .value(description, x),
                y: .value(description, y)
            )
        }
    }
    
    private func setCurrentPoint(proxy: ChartProxy, location: CGPoint, points: [PairXY]) {
        guard let xRaw: Double = proxy.value(atX: location.x) else {
            currentPoint = nil
            return
        }
        guard var selected = points.firstIndex(where: { t in
            t.x >= xRaw
        }) else { return }
        if selected > 0 {
            let center = (points[selected - 1].x + points[selected].x) / 2
            if xRaw < center { selected -= 1 }
        }
        currentPoint = points[selected]
    }
}
