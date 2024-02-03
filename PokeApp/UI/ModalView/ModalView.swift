//
//  ModalView.swift
//  PokeApp
//
//  Created by Nelson Peña on 2/02/24.
//

import SwiftUI

struct ModalView: View {
    
    @Binding var isPresented: Bool
    @State var selectedOption: PokemonType
    let onAccept: (PokemonType) -> Void
    
    var body: some View {
        NavigationView {
            Form {
                pickerView
            }
            .navigationTitle("text_title_modal".localized)
            .navigationBarItems(trailing: Button("text_done_button".localized) {
                isPresented = false
            })
        }
    }
    
    var pickerView: some View {
        Picker("text_title_modal", selection: $selectedOption) {
            ForEach(PokemonType.sortedCases, id: \.self)  { option in
                Text(option.name.capitalized)
            }
        }
        .pickerStyle(WheelPickerStyle())
        .onChange(of: selectedOption) { newValue in
            onAccept(newValue)
        }
    }
}
