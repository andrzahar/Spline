import SwiftUI

struct DataEditor: View {
    @Binding var dataIn: DataIn
    
    @Environment(\.dismiss) private var dismiss
    @FocusState var focusedPair: PairXY?
    
    var body: some View {
            VStack {
                Form {
                    Section (
                        header: Text("Название набора")
                    ) {
                        TextField("Название набора", text: $dataIn.name)
                    }
                    Section (
                        header: Text("Граничные условия"),
                        footer: Text("Значения первой производной функции в крайних точках интерполируемого отрезка")
                    ) {
                        HStack {
                            TextField("Слева", value: $dataIn.boundaryConditions.a, format: .number)
                                .keyboardType(.decimalPad)
                            Spacer()
                            
                            TextField("Справа", value: $dataIn.boundaryConditions.b, format: .number)
                                .keyboardType(.decimalPad)
                            Spacer()
                        }
                    }
                    Section (
                        header: Text("Искомые точки"),
                        footer: Text("Аргументы искомых значений функций. Должны принадлежать интервалу аргументов интерполируемых точек")
                    ) {
                        ForEach($dataIn.findIn) { $item in
                            TextField("x", value: $item.value, format: .number)
                                .keyboardType(.decimalPad)
                        }.onDelete(perform: { indexSet in
                            dataIn.findIn.remove(atOffsets: indexSet)
                        })
                        
                        Button {
                            let newFindIn = FindIn(value: 0.0)
                            dataIn.findIn.append(newFindIn)
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Добавить аргумент")
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                    Section (
                        header: Text("Узлы интерполяции"),
                        footer: Text("Не менее двух узлов")
                    ) {
                        ForEach($dataIn.table) { $item in
                            PairXYRow(pairXY: $item, focusedPair: $focusedPair)
                        }.onDelete(perform: { indexSet in
                            dataIn.table.remove(atOffsets: indexSet)
                        })
                        
                        Button {
                            let newPair = PairXY(x: 0.0, y: 0.0)
                            dataIn.table.append(newPair)
                            focusedPair = newPair
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                Text("Добавить узел")
                            }
                        }
                        .buttonStyle(.borderless)
                    }
                }
            }
#if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
#endif
    }
}

struct DataEditor_Previews: PreviewProvider {
    static var previews: some View {
        DataEditor(dataIn: .constant(DataProvider.createEmpty()))
            .environmentObject(DataProvider())
    }
}
