import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Word.id, order: .forward) private var words: [Word]
    @State private var hasCheckedImport = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack {
            if words.isEmpty {
                ProgressView()
                    .task {
                        guard !hasCheckedImport else { return }
                        hasCheckedImport = true
                        do {
                            try await CSVService.shared.importWords(modelContext: modelContext)
                        } catch {
                            errorMessage = error.localizedDescription
                        }
                    }
            } else {
                TabView {
                    ForEach(words) { word in
                        WordCardView(word: word)
                            .padding(.horizontal)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .automatic))
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }
} 

struct WordCardView_Previews: PreviewProvider {
    static var previews: some View {
        // Приклад слова для прев'ю
        let sampleWord = Word(
            id: 1,
            word: "Hello",
            translation: "Привіт",
            type: "Greeting",
            cefr: "A1",
            phon_br: "/həˈləʊ/",
            phon_n_am: "/hɛˈloʊ/",
            definition: "A common greeting",
            example: "Hello, how are you?"
        )
        
        let sampleWord2 = Word(
            id: 2,
            word: "Goodbye",
            translation: "До побачення",
            type: "Farewell",
            cefr: "A1",
            phon_br: "/ɡʊdˈbaɪ/",
            phon_n_am: "/ɡʊdˈbaɪ/",
            definition: "A common farewell",
            example: "Goodbye, see you later!"
        )
        
        
        // Показуємо WordCardView з прикладом слова
        WordCardView(word: sampleWord)
            .padding()
    }
}

// MARK: - Прев'ю для ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        // Створюємо пустий контейнер для SwiftData (в пам'яті)
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try! ModelContainer(for: Word.self, configurations: config)
        
        // Показуємо ContentView з контейнером
        ContentView()
            .modelContainer(container)
    }
}
