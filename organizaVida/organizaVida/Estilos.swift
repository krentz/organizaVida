import SwiftUI

extension View {
    func estiloBotaoPequeno() -> some View {
        self.padding(8)
            .foregroundColor(.white)
            .background(Color.green)
            .cornerRadius(8)
    }

    func estiloBotaoPadrao() -> some View {
        self.padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .padding(.horizontal)
    }
    
    func estiloViewArredondadaPadrao() -> some View {
        self.padding(.bottom)
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 8)
            .padding()
    }
    
    func gerarConteudoParaCompartilhar(item: Item) -> String {
        var text = "\(item.titulo)\n\n"
        if !item.descricao.isEmpty {
            text += "\(item.descricao)\n\n"
        }
        if !item.itensRelacionados.isEmpty {
            text += NSLocalizedString("items", comment: "") + ":\n"
            for itemFilho in item.itensRelacionados.sorted(by: { !$0.foiExecutado && $1.foiExecutado }) {
                text += "- \(itemFilho.nome) \(itemFilho.foiExecutado ? " ✅" : "")\n"
            }
        } else {
            text += "\(LocalizedStringKey("empty_share_list"))\n"
        }
        return text
    }
}

// MARK: - Haptic Feedback Manager (Recomendado criar um singleton)
class HapticFeedbackManager {
    static let shared = HapticFeedbackManager()
    private init() {}

    func play(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        UIImpactFeedbackGenerator(style: style).impactOccurred()
    }
}

