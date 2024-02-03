import SwiftUI
import Foundation

struct PokemonListView: View {
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @ObservedObject var viewModel: PokemonListViewModel
    private let createPokemonListDetailView: CreatePokemonListDetailView
    @State private var isDetailViewPresented = false
    @State private var showModal = false
    
    init(viewModel: PokemonListViewModel, createPokemonListDetailView: CreatePokemonListDetailView) {
        self.viewModel = viewModel
        self.createPokemonListDetailView = createPokemonListDetailView
    }
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            
            VStack {
                if viewModel.showLoadingSpinner {
                    loadingView
                } else {
                    contentView
                }
            }
        }
        .refreshable {
            viewModel.setup()
        }
        .environment(\.locale, .init(identifier: "es"))
        .accentColor(.black)
    }
    
    // MARK: - Subviews
    
    private var loadingView: some View {
        HStack(spacing: 10) {
            ProgressView().progressViewStyle(.circular)
            Text(viewModel.loaderMensaje)
        }
    }
    
    private var contentView: some View {
        if viewModel.showErrorMessage == nil {
            return AnyView(pokemonGrid)
        } else {
            return AnyView(errorMessageView)
        }
    }
    
    private var pokemonGrid: some View {
        var pokemonDetailViewData: PokemonDetailViewData?
        let adaptiveColumns = [
            GridItem(.adaptive(minimum: 150))
        ]
        return ScrollView {
            LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                ForEach(viewModel.searchResults, id: \.index) { pokemon in
                    let pokemonView = PokemonView(viewModel: viewModel, item: pokemon)
                    pokemonView
                        .onTapGesture {
                            viewModel.fetchDetails(id: pokemon.index) { response in
                                pokemonDetailViewData = PokemonDetailViewData(detail: response)
                                isDetailViewPresented = true
                            }
                        }
                }
                .padding(15)
                .animation(.easeInOut(duration: 0.3), value: viewModel.pokemonList.count)
                .navigationTitle("text_title".localized)
                .navigationBarTitleDisplayMode(.inline)
            }
            
            .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always), prompt: "text_search_pokemon".localized)
            
            .sheet(isPresented: $isDetailViewPresented) {
                if let viewData = pokemonDetailViewData {
                    createPokemonListDetailView.create(with: viewData)
                }
            }
            .navigationBarItems(
                trailing:
                    HStack {
                        Button(action: {
                            showModal.toggle()
                        }) {
                            Image(systemName: viewModel.selectedType == .all ? "line.horizontal.3.decrease.circle":  "line.horizontal.3.decrease.circle.fill")
                        }
                        .sheet(isPresented: $showModal) {
                            ModalView(isPresented: $showModal,
                                      selectedOption: viewModel.selectedType,
                                      onAccept: { pokemonType in
                                viewModel.selectedType = pokemonType
                            })
                        }
                    }
            )
        }
    }
    
    var errorMessageView: some View {
        Button(viewModel.showErrorMessage!) {
            viewModel.setup()
        }.foregroundColor(.blue)
    }
}

// MARK: - Preview

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListFactory().create()
    }
}
