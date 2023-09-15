import SwiftUI

struct AboutApp: View {
    
    var body: some View {
        ZStack {
            Form {
                Section {
                    LabeledContent("Название программы", value: "Интерполятор функций")
                    LabeledContent("Тип интерполяции", value: "Нелокальный кубический сплайн")
                    LabeledContent("Тип граничных условий", value: "I")
                }
                Section {
                    LabeledContent("Авторы", value: "Захаров Андрей, Шнякина Елена")
                }
                Section {
                    LabeledContent("Версия", value: "1.0")
                    LabeledContent("Год", value: "2023")
                }
            }
        }
        .navigationTitle("О программе")
    }
}
