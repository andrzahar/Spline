import SwiftUI

/*
 Парсинг входного файла и сохранение его результатов
 */
class DataProvider: ObservableObject {
    
    @Published var allData: [DataIn] = []
    
    private var cache: [UUID: Calculator] = [:]
    
    private static func getExampleFileURL() -> URL {
        Bundle.main.url(forResource: "data", withExtension: "json")!
    }
    
    private static func getUserDataURL() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("user.data")
    }
    
    func getCalculator(data: DataIn) -> Calculator {
        if let calc = cache[data.id] {
            return calc
        } else {
            let calc = Calculator(dataIn: data)
            cache[data.id] = calc
            return calc
        }
    }
    
    func add(_ dataIn: DataIn) {
        allData.append(dataIn)
    }
    
    func remove(_ dataIn: DataIn) {
        allData.removeAll { $0.id == dataIn.id}
    }
    
    func replace(_ newDataIn: DataIn) {
        let index = allData.firstIndex{ $0.id == newDataIn.id }!
        allData.remove(at: index)
        allData.insert(newDataIn, at: index)
        cache.removeValue(forKey: newDataIn.id)
    }
    
    func sortedData() -> Binding<[DataIn]> {
        Binding<[DataIn]>(
            get: {
                self.allData
                    .sorted { $0.name < $1.name }
            },
            set: { allData in
                for dataIn in allData {
                    if let index = self.allData.firstIndex(where: { $0.id == dataIn.id }) {
                        self.allData[index] = dataIn
                    }
                }
            }
        )
    }
    
    func getBindingToEvent(_ dataIn: DataIn) -> Binding<DataIn>? {
        Binding<DataIn>(
            get: {
                guard let index = self.allData.firstIndex(where: { $0.id == dataIn.id }) else { return DataProvider.createEmpty() }
                return self.allData[index]
            },
            set: { dataIn in
                guard let index = self.allData.firstIndex(where: { $0.id == dataIn.id }) else { return }
                self.allData[index] = dataIn
            }
        )
    }
    
    func load() {
        if let dataIn = loadFrom(url: DataProvider.getUserDataURL()) {
            allData = dataIn
        } else if let dataIn = loadFrom(url: DataProvider.getExampleFileURL()) {
            allData = dataIn
        }
    }
    
    private func loadFrom(url: URL) -> [DataIn]? {
        do {
            let rawData = try Data(contentsOf: url)
            return try JSONDecoder().decode([DataIn].self, from: rawData)
        } catch _ {
            return nil
        }
    }
    
    func save() {
        do {
            let fileURL = DataProvider.getUserDataURL()
            let data = try JSONEncoder().encode(allData)
            try data.write(to: fileURL, options: [.atomic, .completeFileProtection])
            print("Events saved")
        } catch {
            print("Unable to save")
        }
    }
    
    static func createEmpty() -> DataIn {
        return DataIn (
            name: "",
            boundaryConditions: BoundaryConditions(a: 0.0, b: 0.0),
            findIn: [],
            table: []
        )
    }
}
