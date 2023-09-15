import SwiftUI
import Charts

struct ContentView: View {
    @ObservedObject var dataProvider: DataProvider
    
    @State private var openEditor = false
    @State private var editedDataIn = DataProvider.createEmpty()
    @State private var isNew = false
    @State private var openInfo = false
    
    @State private var selection: DataIn?
    @State private var showMoreInfo: Bool = false
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selection) {
                ForEach(dataProvider.sortedData()) { $data in
                    DataRow(data: data)
                        .tag(data)
                        .swipeActions(edge: .leading) {
                            Button {
                                selection = nil
                                editedDataIn = data
                                isNew = false
                                openEditor = true
                            } label: {
                                Label("Изменить", systemImage: "pencil")
                            }
                            .tint(.orange)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                selection = nil
                                dataProvider.remove(data)
                            } label: {
                                Label("Удалить", systemImage: "trash")
                            }
                        }
                }
            }
            .navigationTitle("Сплайны")
            .toolbar {
                ToolbarItem {
                    Button {
                        editedDataIn = DataProvider.createEmpty()
                        openEditor = true
                        isNew = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem {
                    Button {
                        openInfo = true
                    } label: {
                        Image(systemName: "info.circle")
                    }
                }
            }
        .sheet(isPresented: $openEditor) {
            NavigationStack {
                DataEditor(dataIn: $editedDataIn)
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Отмена") {
                                openEditor = false
                            }
                        }
                        ToolbarItem {
                            Button {
                                if isNew {
                                    dataProvider.add(editedDataIn)
                                } else {
                                    dataProvider.replace(editedDataIn)
                                }
                                openEditor = false
                            } label: {
                                Text(isNew ? "Добавить" : "Изменить")
                            }
                            .disabled(
                                editedDataIn.name.isEmpty || 
                                editedDataIn.table.count < 2 ||
                                editedDataIn.findIn.isEmpty
                            )
                        }
                    }
                }
            }
        .sheet(isPresented: $openInfo) {
            NavigationStack {
                AboutApp()
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Закрыть") {
                                openInfo = false
                            }
                        }
                    }
            }
        }
        } detail: {
            ZStack {
                ForEach(dataProvider.allData) { data in
                    let calc = dataProvider.getCalculator(data: data)
                    DataView(data: data, showMoreInfo: $showMoreInfo, isPresented: data.id == selection?.id)
                        .environmentObject(calc)
                }
                if selection == nil {
                    Text("Выберете данные")
                        .foregroundStyle(.secondary)
                }
            }
        }
    }
}
