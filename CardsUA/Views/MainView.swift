import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Word.id, order: .forward) private var words: [Word]
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink(destination: ContentView()) {
                        Label("Flashcards", systemImage: "rectangle.stack")
                    }
                    
                    NavigationLink(destination: Text("Dictionary View")) {
                        Label("Dictionary", systemImage: "book")
                    }
                    
                    NavigationLink(destination: Text("Practice View")) {
                        Label("Practice", systemImage: "brain")
                    }
                } header: {
                    Text("Study")
                }
                
                Section {
                    NavigationLink(destination: Text("Settings View")) {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    NavigationLink(destination: Text("About View")) {
                        Label("About", systemImage: "info.circle")
                    }
                } header: {
                    Text("More")
                }
            }
            .navigationTitle("CardsUA")
            .listStyle(.insetGrouped)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Word.self, configurations: config)
    
    return MainView()
        .modelContainer(container)
} 