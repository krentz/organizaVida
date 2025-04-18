import SwiftUI
import SwiftData

struct FormularioView: View {
    @Environment(\.modelContext) private var modelContext
        @Environment(\.dismiss) private var dismiss

        @State private var titulo = ""
        @State private var descricao = ""
        var item: Item?
        var itemPai: Item?

        init(item: Item? = nil, itemPai: Item? = nil) {
            self.item = item
            self.itemPai = itemPai
            _titulo = State(initialValue: item?.titulo ?? "")
            _descricao = State(initialValue: item?.descricao ?? "")
        }

        var body: some View {
            NavigationStack{
                Form {
                    TextField("Título", text: $titulo)
                    TextField("Descrição", text: $descricao)
                    TextEditor(text: $descricao)
                        .frame(height: 100)
                    Button("OK") {
                        let novoItem = Item(titulo: titulo, descricao: descricao)
                        modelContext.insert(novoItem)
                        dismiss()
                    }
                }
                .navigationTitle(item == nil ? "Novo Item" : "Editar Item")
            }
        }
    }
