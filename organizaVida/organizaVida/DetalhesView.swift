import SwiftUI
import SwiftData

struct DetalheItemView: View {
    let item: Item
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
                    }
                    .listStyle(PlainListStyle())
                }else{
                    VStack {
                        Spacer()
                        Text("Ainda não tem nenhum item cadastrado, por favor adicione itens a lista que aparecerá aqui.")
                           .foregroundColor(.gray)
                           .multilineTextAlignment(.center)
                           .frame(maxWidth: .infinity, alignment: .center)
                           .padding(.top, -200)
                        Spacer()
                    }
                }
                
                HStack {
                    TextField("Novo Item", text: $nomeItemFilho)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    Button("Adicionar") {
                       
                        
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
}
