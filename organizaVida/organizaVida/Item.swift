import Foundation
import SwiftData

@Model
class Item: Identifiable {
    var titulo: String
    var descricao: String
    var itensRelacionados: [ItemFilho]

    init(titulo: String, descricao: String, itensRelacionados: [ItemFilho] = []) {
        self.titulo = titulo
        self.descricao = descricao
        self.itensRelacionados = itensRelacionados
    }
}

@Model
class ItemFilho: Identifiable {
    var id = UUID()
    var nome: String
    var foiExecutado: Bool
    
    init(nome: String, foiExecutado: Bool) {
        self.nome = nome
        self.foiExecutado = foiExecutado
    }
}

extension Item {
    func progress() -> Double {
        if itensRelacionados.isEmpty {
            return 0
        }
        let executados = itensRelacionados.filter { $0.foiExecutado }.count
        return Double(executados) / Double(itensRelacionados.count)
    }
}
