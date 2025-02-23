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



