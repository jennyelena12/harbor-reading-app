import Foundation

class FavoritesManager: ObservableObject {
    @Published var favorites: [FavoriteSentence] = []
    
    private let userDefaultsKey = "harbor_favorites"
    
    init() {
        loadFavorites()
    }
    
    func addFavorite(_ sentence: FavoriteSentence) {
        favorites.append(sentence)
        saveFavorites()
    }
    
    func removeFavorite(_ id: UUID) {
        favorites.removeAll { $0.id == id }
        saveFavorites()
    }
    
    func searchFavorites(_ query: String) -> [FavoriteSentence] {
        if query.isEmpty {
            return favorites
        }
        return favorites.filter { sentence in
            sentence.text.localizedCaseInsensitiveContains(query) ||
            sentence.bookTitle.localizedCaseInsensitiveContains(query) ||
            sentence.chapterTitle.localizedCaseInsensitiveContains(query)
        }
    }
    
    func getFavoritesByBook(_ bookTitle: String) -> [FavoriteSentence] {
        favorites.filter { $0.bookTitle == bookTitle }
    }
    
    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favorites) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private func loadFavorites() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? JSONDecoder().decode([FavoriteSentence].self, from: data) {
            self.favorites = decoded
        }
    }
}
