import SwiftUI

struct PopupAdicionarTopico: View {
    @Binding var mostrarPopup: Bool
    @State var tituloLocal: String = ""
    @State var descricaoLocal: String = ""
    @State var itensFilhoEditaveis: [ItemFilho] = []

    var itemParaEditar: Item?

    @State private var nomeNovoItemFilho: String = ""
    @State private var indiceItemEmEdicao: UUID?
    @FocusState private var textFieldEmFoco: UUID?

    var onSave: (String, String, [ItemFilho]) -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField(LocalizedStringKey("list_name"), text: $tituloLocal)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)

                TextField(LocalizedStringKey("description_optional"), text: $descricaoLocal)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .padding(.horizontal)

                HStack {
                    TextField(LocalizedStringKey("new_item"), text: $nomeNovoItemFilho)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                    Button(LocalizedStringKey("add")) {
                        if !nomeNovoItemFilho.isEmpty {
                            let novoItem = ItemFilho(nome: nomeNovoItemFilho, foiExecutado: false)
                            withAnimation(.easeInOut(duration: 0.2)) {
                                itensFilhoEditaveis.append(novoItem)
                                HapticFeedbackManager.shared.play(.light)
                            }
                            nomeNovoItemFilho = ""
                        }
                    }
                    .estiloBotaoPequeno()
                }
                .padding(.horizontal)
                .padding(.bottom)

                Spacer()

                if !itensFilhoEditaveis.isEmpty { // Usar itensFilhoEditaveis
                    Text("items", bundle: .main)
                        .font(.subheadline)
                        .padding(.horizontal)

                    List {
                        ForEach($itensFilhoEditaveis) { $itemFilho in // Use $ para Binding para ItemFilho
                            HStack {
                                Image(systemName: "circle")
                                    .foregroundColor(.black)
                                    .padding(.trailing, 5)

                                if itemFilho.id == indiceItemEmEdicao {
                                    TextField(LocalizedStringKey("edit_list"), text: $itemFilho.nome)
                                        .focused($textFieldEmFoco, equals: itemFilho.id)
                                        .onSubmit {
                                            indiceItemEmEdicao = nil
                                        }
                                } else {
                                    Text(itemFilho.nome)
                                        .onTapGesture {
                                            indiceItemEmEdicao = itemFilho.id
                                            DispatchQueue.main.async {
                                                textFieldEmFoco = itemFilho.id
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
            }
            .navigationTitle(itemParaEditar == nil ? LocalizedStringKey("add_new_list") : LocalizedStringKey("edit_list_title"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(LocalizedStringKey("cancelButton")) {
                        mostrarPopup = false
                        HapticFeedbackManager.shared.play(.light)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(itemParaEditar == nil ? LocalizedStringKey("add") : LocalizedStringKey("saveButton")) {
                        onSave(tituloLocal, descricaoLocal, itensFilhoEditaveis)
                        mostrarPopup = false
                        HapticFeedbackManager.shared.play(.medium)
                    }
                    .disabled(tituloLocal.isEmpty)
                }
            }
            .onAppear {
                if let item = itemParaEditar {
                    tituloLocal = item.titulo
                    descricaoLocal = item.descricao
                    itensFilhoEditaveis = item.itensRelacionados.map { ItemFilho(nome: $0.nome, foiExecutado: $0.foiExecutado) }
                } else {
                    tituloLocal = ""
                    descricaoLocal = ""
                    itensFilhoEditaveis = []
                    nomeNovoItemFilho = ""
                    indiceItemEmEdicao = nil
                }
            }
        }
    }

    func removerItemFilho(at offsets: IndexSet) {
        itensFilhoEditaveis.remove(atOffsets: offsets)
        HapticFeedbackManager.shared.play(.light)
    }

    func moverItemFilho(from source: IndexSet, to destination: Int) {
        itensFilhoEditaveis.move(fromOffsets: source, toOffset: destination)
    }
}
