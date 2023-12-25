//
//  ___FILEHEADER___
//

import SwiftUI
import ComposableArchitecture

public struct ___VARIABLE_productName___View: View {
    private let store: StoreOf<___VARIABLE_productName___Feature>
    
    public init(store: StoreOf<___VARIABLE_productName___Feature>) {
        self.store = store
    }
    
    public var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}

#Preview {
    ___VARIABLE_productName___View(
        store: .init(
            initialState: .init(),
            reducer: ___VARIABLE_productName___Feature.init
        )
    )
}
