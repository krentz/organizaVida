import SwiftUI

struct PopupAdicionarTopico: View {
    @Binding var mostrarPopup: Bool
    @Binding var titulo: String
    @Binding var descricao: String
    @Binding var itensFilhoRelacionados: [ItemFilho]

    @State private var nomeNovoItemFilho: String = ""
    @State private var indiceItemEmEdicao: UUID?
    @FocusState private var textFieldEmFoco: UUID?

    var onAdicionar: (String, String, [ItemFilho]) -> Void

    var body: some View {
        VStack {
            VStack {
                Text("Adicionar nova Lista")
                    .font(.headline)
                    .padding(.top)

                TextField("Nome da lista", text: $titulo)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                TextField("Descrição (opcional)", text: $descricao)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.horizontal)

                HStack {
                    TextField("Novo item", text: $nomeNovoItemFilho)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)

                    Button("Adicionar") {
                        if !nomeNovoItemFilho.isEmpty {
                            let novoItem = ItemFilho(nome: nomeNovoItemFilho, foiExecutado: false)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                itensFilhoRelacionados.append(novoItem)
                            }
                            nomeNovoItemFilho = ""
                        }
                    }
                    .estiloBotaoPequeno()
                }
                .padding(.horizontal)
            }
            .padding(.bottom)

            Spacer()

            if !itensFilhoRelacionados.isEmpty {
                Text("Items:")
                    .font(.subheadline)
                    .padding(.horizontal)

                List {
                    ForEach($itensFilhoRelacionados) { $item in
                        HStack {
                            Image(systemName: "circle")
                                .foregroundColor(.black)
                                .padding(.trailing, 5)

                            if item.id == indiceItemEmEdicao {
                                TextField("Editar Item", text: $item.nome)
                                    .focused($textFieldEmFoco, equals: item.id)
                                    .onSubmit {
                                        indiceItemEmEdicao = nil
                                    }
                            } else {
                                Text(item.nome)
                                    .onTapGesture {
                                        indiceItemEmEdicao = item.id
                                        DispatchQueue.main.async {
                                            textFieldEmFoco = item.id
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                        .listRowBackground(Color(.systemGray6).opacity(0.3))
                        .cornerRadius(8)
                    }
                    .onDelete(perform: removerItemFilho)
                    .onMove(perform: moverItemFilho)
                }
                .frame(maxHeight: .infinity)
                .cornerRadius(8)
                .padding(.horizontal)
                .listStyle(PlainListStyle())
            }

            Button("Adicionar") {
                onAdicionar(titulo, descricao, itensFilhoRelacionados)
                mostrarPopup = false
            }
            .estiloBotaoPadrao()
            .padding(.bottom)
            .disabled(titulo.isEmpty)
            .opacity(titulo.isEmpty ? 0.5 : 1.0)
        }
        .padding()
        .onDisappear {
            titulo = ""
            descricao = ""
            itensFilhoRelacionados = []
            nomeNovoItemFilho = ""
            indiceItemEmEdicao = nil
        }
    }

    func removerItemFilho(at offsets: IndexSet) {
        itensFilhoRelacionados.remove(atOffsets: offsets)
    }

    func moverItemFilho(from source: IndexSet, to destination: Int) {
        itensFilhoRelacionados.move(fromOffsets: source, toOffset: destination)
    }
}
