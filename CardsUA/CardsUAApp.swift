import SwiftUI
import SwiftData



// MARK: - App Entry

@main
struct WordsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Word.self)
    }
}
