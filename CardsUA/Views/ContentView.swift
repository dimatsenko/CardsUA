import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Word.id, order: .forward) private var words: [Word]
    @Query private var levels: [Level]
    @State private var hasCheckedImport = false
    @State private var errorMessage: String?
    
    var filteredWords: [Word] {
        // Get selected levels
        let selectedLevels = levels.filter { $0.isSelected }
        
        // If no levels are selected, return empty array
        if selectedLevels.isEmpty {
            return []
        }
        
        // Filter words based on selected CEFR levels and shuffle them
        return words.filter { word in
            selectedLevels.contains { level in
                word.cefr.lowercased() == level.name.lowercased()
            }
        }.shuffled()
    }
    
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
                    if filteredWords.isEmpty {
                        VStack(spacing: 16) {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.system(size: 50))
                                .foregroundColor(.gray)
                            
                            Text("No Words to Display")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.gray)
                            
                            Text("Please select levels in Dictionary")
                                .font(.body)
                                .foregroundColor(.gray)
                            
                            NavigationLink(destination: DictionaryView()) {
                                Text("Go to Dictionary")
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                    .padding(.top, 8)
                            }
                        }
                        .padding(.horizontal)
                    } else {
                        ForEach(filteredWords) { word in
                            WordCardView(word: word)
                                .padding(.horizontal)
                        }
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



