import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var mostrarFormulario = false
    @Query private var itens: [Item]
    @State private var itemParaEditar: Item?
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        NavigationView {
            VStack {
                contentViewBody
            }
            .navigationTitle(itens.isEmpty ? "" : LocalizedStringKey("myLists"))
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        itemParaEditar = nil
                        mostrarFormulario = true
                    } label: {
                        Image(systemName: "plus.circle")
                            .font(.title2)
                    }
                }
            }
            .sheet(isPresented: $mostrarFormulario) {
                PopupAdicionarTopico(
                    mostrarPopup: $mostrarFormulario,
                    itemParaEditar: itemParaEditar
                ) { newTitulo, newDescricao, newItensFilhoRelacionados in
                    if let itemToUpdate = itemParaEditar {
                        itemToUpdate.titulo = newTitulo
                        itemToUpdate.descricao = newDescricao
                        itemToUpdate.itensRelacionados = newItensFilhoRelacionados
                    } else {
                        let novoItem = Item(titulo: newTitulo, descricao: newDescricao, itensRelacionados: newItensFilhoRelacionados)
                        modelContext.insert(novoItem)
                    }
                }
            }
            .onChange(of: mostrarFormulario) { oldValue, newValue in
                if !newValue {
                    itemParaEditar = nil
                }
            }
        }
    }
        
    @ViewBuilder
    var contentViewBody: some View {
        if itens.count != 0 {
            ItemListView(
                itens: itens,
                itemParaEditar: $itemParaEditar,
                mostrarFormulario: $mostrarFormulario,
                excluirItemIndividual: excluirItemIndividual,
                gerarConteudoParaCompartilhar: gerarConteudoParaCompartilhar,
                excluirItens: excluirItens
            )
        } else {
            VStack {
                WelcomeCardView(
                    title: NSLocalizedString("welcome_card_title", comment: ""),
                    message: NSLocalizedString("welcome_card_message", comment: ""),
                    buttonText: NSLocalizedString("create_first_list_button", comment: "")
                ) {
                    itemParaEditar = nil
                    mostrarFormulario = true
                }
                .padding(.top, 50)
                Spacer()
            }
        }
    }
        
    struct WelcomeCardView: View {
        let title: String
        let message: String
        let buttonText: String
        let buttonAction: () -> Void

        var body: some View {
            VStack(spacing: 20) {
                Image(systemName: "checklist.checked")
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)

                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                Button(buttonText) {
                    buttonAction()
                    HapticFeedbackManager.shared.play(.light)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 10)
            }
            .padding(25)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            )
            .padding(.horizontal, 40)
            .frame(maxWidth: .infinity)
        }
    }
    
    struct AdicionarListaBotaoToolbar: View {
        @Binding var mostrarFormulario: Bool

        var body: some View {
            Button {
                mostrarFormulario = true
            } label: {
                Image(systemName: "plus.circle")
                    .font(.title2)
            }
        }
    }
    
    func excluirItens(offsets: IndexSet) {
        withAnimation {
            offsets.map { itens[$0] }.forEach(modelContext.delete)
            HapticFeedbackManager.shared.play(.medium)
        }
    }

    func excluirItemIndividual(_ item: Item) {
        withAnimation {
            modelContext.delete(item)
            HapticFeedbackManager.shared.play(.medium)
        }
    }
}

struct ItemListView: View {
    let itens: [Item]
    @Binding var itemParaEditar: Item?
    @Binding var mostrarFormulario: Bool
    let excluirItemIndividual: (Item) -> Void
    let gerarConteudoParaCompartilhar: (Item) -> String
    let excluirItens: (IndexSet) -> Void

    var body: some View {
        List {
            ForEach(itens) { item in
                NavigationLink(destination: DetalheItemView(item: item)) {
                    ItemListaCelula(item: item)
                }
                .contextMenu {
                    ShareLink(item: gerarConteudoParaCompartilhar(item)) {
                        Label(LocalizedStringKey("shareItem"), systemImage: "square.and.arrow.up")
                    }
                    Button {
                        itemParaEditar = item
                        mostrarFormulario = true
                    } label: {
                        Label(LocalizedStringKey("editItem"), systemImage: "pencil")
                    }
                    Button(role: .destructive) {
                        excluirItemIndividual(item)
                    } label: {
                        Label(LocalizedStringKey("removeItem"), systemImage: "trash")
                    }
                }
            }
            .onDelete(perform: excluirItens)
        }
        .listStyle(PlainListStyle())
    }
}


struct ItemListaCelula: View {
    let item: Item

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.titulo)
                    .font(.headline)
                Text(item.descricao)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                BarraDeProgresso(item: item)
            }
            Spacer()

            Text("\(Int(item.progress() * 100))%")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 35, alignment: .trailing)
        }
        .padding(.vertical, 8)
    }
}

struct BarraDeProgresso: View {
    let item: Item

    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .frame(height: 5)
                .foregroundColor(Color.gray.opacity(0.3))
                .overlay(alignment: .leading) {
                    Rectangle()
                        .frame(width: geometry.size.width * CGFloat(item.progress()), height: 5)
                        .foregroundColor(Color.green)
                        .cornerRadius(2.5)
                }
                .cornerRadius(2.5)
        }
        .frame(height: 5)
    }
}
