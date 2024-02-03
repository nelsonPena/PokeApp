import SwiftUI

/// Vista que muestra una lista de Pokémon.
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
    
    /// Vista de carga que se muestra mientras se obtienen los datos.
    private var loadingView: some View {
        HStack(spacing: 10) {
            ProgressView().progressViewStyle(.circular)
            Text(viewModel.loaderMensaje)
        }
    }
    
    /// Vista principal que muestra la lista de Pokémon o un mensaje de error.
    private var contentView: some View {
        if viewModel.showErrorMessage == nil {
            return AnyView(pokemonGrid)
        } else {
            return AnyView(errorMessageView(viewModel: viewModel) {
                viewModel.setup()
            })
        }
    }
    
    /// Vista de cuadrícula que muestra la lista de Pokémon.
    private var pokemonGrid: some View {
        var pokemonDetailViewData: PokemonDetailViewData?
        let adaptiveColumns = [
            GridItem(.adaptive(minimum: 150))
        ]
        return ScrollView {
            LazyVGrid(columns: adaptiveColumns, spacing: 10) {
                ForEach(viewModel.searchResults, id: \.index) { pokemon in
                    PokemonView(viewModel: viewModel, item: pokemon)
                        .onTapGesture {
                            viewModel.fetchDetails(with: pokemon.index) { response in
                                let detailPresentableItem = PokemonDetailPresentableItem(domainModel: response)
                                pokemonDetailViewData = PokemonDetailViewData(detail: detailPresentableItem)
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
                        filterButton
                    }
            )
        }
    }
    
    /// Botón para mostrar un modal de filtrado de tipo de Pokémon.
    var filterButton: some View {
        Button(action: {
            showModal.toggle()
        }) {
            Image(systemName: viewModel.selectedType == .all ? "line.horizontal.3.decrease.circle":  "line.horizontal.3.decrease.circle.fill")
        }
        .actionSheet(isPresented: $showModal) {
            actionSheet
        }
    }
    
    /// Hoja de acción que muestra opciones de filtrado por tipo de Pokémon.
    var actionSheet: ActionSheet {
        ActionSheet(
            title: Text("text_title_modal".localized),
            buttons: [
                .default(Text(PokemonType.all.name)) {
                    viewModel.selectedType = .all
                },
                .cancel()
            ]
            + PokemonType.sortedCases
                .filter { $0 != .all } // Filtrar el tipo .all
                .map { type in
                    .default(Text(type.name.capitalized)) {
                        viewModel.selectedType = type
                    }
                }
        )
    }
    
    /// Vista que muestra un mensaje de error.
    struct errorMessageView: View  {
        @State var viewModel: PokemonListViewModel
        let action: () -> Void
        
        var body: some View {
            Spacer()
            Button(action: action) {
                Text(viewModel.showErrorMessage!)
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, maxHeight: 30)
            }.foregroundColor(.red)
            .font(.system(size: 24, weight: .bold))
            .background(.red.opacity(0.5))
            .cornerRadius(12)
            .frame(maxWidth: .infinity)
            .padding()
            .lineLimit(1)
        }
    }
}

// MARK: - Preview

struct PokemonList_Previews: PreviewProvider {
    static var previews: some View {
        PokemonListFactory().create()
    }
}
