import SwiftUI
import SwiftData



// MARK: - App Entry

@main
struct WordsApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .modelContainer(for: [Word.self, Level.self])
    }
}
