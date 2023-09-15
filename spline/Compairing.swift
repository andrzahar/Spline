import Foundation

/*
 Таблица значений функции в искомой точке
 */
struct CompairingTable: Identifiable, Hashable {
    let id = UUID()
    let x: String
    var rows: [CompairingRow]
}

/*
 Строка таблицы CompairingTable
 */
struct CompairingRow: Identifiable, Hashable {
    let id = UUID()
    let numberOfPoint: String
    let y: String
    let delta: String
}
