import SwiftUI

//Não está sendo usado mas serve de poppup exemplo

struct PopupAdicionarItemFilho: View {
    @Binding var mostrarPopup: Bool
    @Binding var nomeItemFilho: String
    var onAdicionar: () -> Void

    var body: some View {
        VStack {
            Text("Adicionar Item Filho")
                .font(.headline)
                .padding(.top)
            TextField("Nome do Item Filho", text: $nomeItemFilho)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            Button("Adicionar Filho") {
                onAdicionar()
                mostrarPopup = false
            }
            .estiloBotaoPadrao()
        }
        .estiloViewArredondadaPadrao()
    }
}
