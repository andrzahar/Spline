import SwiftUI

/*
 Точка входа программы. Указывает окно при запуске программы 
 */
@main
struct splineApp: App {
    @StateObject private var dataProvider = DataProvider()
    
    var body: some Scene {
        WindowGroup {
            ContentView(dataProvider: dataProvider)
                .task {
                    dataProvider.load()
                }
                .onChange(of: dataProvider.allData) { _ in
                    dataProvider.save()
                }
        }
    }
}
