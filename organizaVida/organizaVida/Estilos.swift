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
}
