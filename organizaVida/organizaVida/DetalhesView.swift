import SwiftUI
import SwiftData

struct DetalheItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: Item
    @State private var mostrarPopup = false
    @State private var nomeItemFilho = ""

    var body: some View {
        ZStack {
            VStack {
                Text(item.titulo).font(.title)
                Text(item.descricao)
                
                if item.itensRelacionados.count != 0 {
                    List {
                        ForEach(item.itensRelacionados.sorted(by: { !$0.foiExecutado && $1.foiExecutado })) { itemFilho in
                            HStack {
                                Button(action: {
                                    withAnimation {
                                        itemFilho.foiExecutado.toggle()
                                    }
                                }) {
                                    Image(systemName: itemFilho.foiExecutado ? "checkmark.square" : "square")
                                        .foregroundColor(itemFilho.foiExecutado ? .green : .gray)
                                }
                                Text(itemFilho.nome)
                            }
                        }
                        .onDelete(perform: removerItemFilho)
                    }
                    .listStyle(PlainListStyle())
                }else{
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
                
                HStack {
                    TextField(LocalizedStringKey("new_item"), text: $nomeItemFilho)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    Button(LocalizedStringKey("add")) {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            item.itensRelacionados.append(ItemFilho(nome: nomeItemFilho, foiExecutado: false))
                        }
                        nomeItemFilho = ""
                    }
                    .estiloBotaoPequeno()
                    .disabled(nomeItemFilho.isEmpty)
                    .opacity(nomeItemFilho.isEmpty ? 0.5 : 1.0)
                }
                .padding(.horizontal)
            }
            .padding()

        }
    }
    
    func removerItemFilho(at offsets: IndexSet) {
        withAnimation {
            offsets.map { item.itensRelacionados[$0] }.forEach { itemFilhoParaRemover in
                modelContext.delete(itemFilhoParaRemover)
            }
        }
    }
}
