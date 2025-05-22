import SwiftUI
import SwiftData

struct DetalheItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var item: Item
    @State private var mostrarPopup = false
    @State private var nomeItemFilho = ""
    @State private var isShareSheetShowing = false
    
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
                                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
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
                            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
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
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                ShareLink(item: gerarConteudoParaCompartilhar(item: item)) {
                    Image(systemName: "square.and.arrow.up")
                }
            }
        }
    }
    
    func removerItemFilho(at offsets: IndexSet) {
           withAnimation {
               // Primeiro, obtenha os itens a serem removidos da LISTA ORIGINAL
               // Isso evita problemas com a array temporária ordenada do ForEach
               let itensParaDeletar = offsets.map { item.itensRelacionados.sorted(by: { !$0.foiExecutado && $1.foiExecutado })[$0] }

               // Depois, remova os itens da relação no Item pai
               item.itensRelacionados.removeAll { itemFilho in
                   itensParaDeletar.contains(where: { $0.id == itemFilho.id }) // Compare por ID
               }

               // E então, delete-os do ModelContext
               for itemFilho in itensParaDeletar {
                   modelContext.delete(itemFilho)
               }
               HapticFeedbackManager.shared.play(.medium)
           }
       }

}
