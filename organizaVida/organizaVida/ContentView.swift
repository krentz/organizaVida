import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var mostrarFormulario = false
        @Query private var itens: [Item]
        @State private var itemParaEditar: Item?
    @Environment(\.modelContext) private var modelContext

    @State private var titulo = ""
    @State private var descricao = ""
    @State private var listaItensFilhoRelacionados: [ItemFilho] = []
     
    var body: some View {
        NavigationStack {
            VStack {
                AdicionarListaBotao(mostrarFormulario: $mostrarFormulario)

                if itens.count != 0 {
                    List {
                        ForEach(itens) { item in
                            NavigationLink(destination: DetalheItemView(item: item)) {
                                ItemListaCelula(item: item)
                            }
                        }
                        .onDelete(perform: excluirItens)
                        .listStyle(PlainListStyle())
                    }
                } else {
                    VStack {
                        Spacer()
                        Text("empty_list", bundle: .main)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, -200)
                        Spacer()
                    }
                }
            }
            .sheet(isPresented: $mostrarFormulario) { // Move o .sheet para fora do if
                PopupAdicionarTopico(
                    mostrarPopup: $mostrarFormulario,
                    titulo: $titulo,
                    descricao: $descricao,
                    itensFilhoRelacionados: $listaItensFilhoRelacionados
                ) { titulo, descricao, itensFilhoRelacionados in
                    adicionarTopico()
                }
            }
            .onChange(of: mostrarFormulario) { oldValue, newValue in
                if !newValue {
                    itemParaEditar = nil
                }
            }
        }
    }
    
    struct AdicionarListaBotao: View {
        @Binding var mostrarFormulario: Bool

        var body: some View {
            HStack {
                Circle()
                    .frame(width: 30, height: 30)
                    .foregroundColor(.blue)
                    .overlay {
                        Image(systemName: "plus")
                            .foregroundColor(.white)
                    }
                Text("add_new_topic", bundle: .main)
                    .font(.headline)
            }
            .padding()
            .onTapGesture {
                mostrarFormulario = true
            }
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
    
    func adicionarTopico() {
        let novoItem = Item(titulo: titulo, descricao: descricao, itensRelacionados: listaItensFilhoRelacionados)
        modelContext.insert(novoItem)
        titulo = ""
        descricao = ""
        listaItensFilhoRelacionados = []
    }
    
    func excluirItens(offsets: IndexSet) {
        withAnimation {
            offsets.map { itens[$0] }.forEach(modelContext.delete)
        }
    }
    
    func moverItemFilho(from source: IndexSet, to destination: Int) {
        listaItensFilhoRelacionados.move(fromOffsets: source, toOffset: destination)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
