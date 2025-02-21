import SwiftUI
import SwiftData



// MARK: - CSV Parser (Semicolon version)

func parseCSVLine(line: String) -> [String] {
    var result = [String]()
    var currentField = ""
    var insideQuotes = false
    var previousChar: Character?
    
    for char in line {
        if char == "\"" {
            if insideQuotes && previousChar == "\"" {
                currentField.append(char)
                previousChar = nil
            } else {
                insideQuotes.toggle()
            }
        } else if char == ";" && !insideQuotes {
            result.append(currentField)
            currentField = ""
        } else {
            currentField.append(char)
        }
        previousChar = char
    }
    result.append(currentField)
    return result
}

// MARK: - CSV Importer

func importCSV(modelContext: ModelContext) {
    guard let fileUrl = Bundle.main.url(forResource: "Words", withExtension: "csv") else {
        print("CSV file not found")
        return
    }
    
    do {
        let existingCount = try modelContext.fetchCount(FetchDescriptor<Word>())
        guard existingCount == 0 else {
            print("Data already exists, skipping import")
            return
        }
        
        let data = try String(contentsOf: fileUrl, encoding: .utf8)
        let rows = data.components(separatedBy: .newlines)
        
        for row in rows.dropFirst() {
            let trimmed = row.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.isEmpty { continue }
            
            let columns = parseCSVLine(line: trimmed)
            guard columns.count >= 9 else { continue }
            
            let cleanedColumns = columns.map {
                $0.trimmingCharacters(in: .whitespacesAndNewlines)
                    .replacingOccurrences(of: "^\"|\"$", with: "", options: .regularExpression)
            }
            
            if let id = Int(cleanedColumns[0]) {
                let newWord = Word(
                    id: id,
                    word: cleanedColumns[1],
                    translation: cleanedColumns[2],
                    type: cleanedColumns[3],
                    cefr: cleanedColumns[4],
                    phon_br: cleanedColumns[5],
                    phon_n_am: cleanedColumns[6],
                    definition: cleanedColumns[7],
                    example: cleanedColumns[8]
                )
                modelContext.insert(newWord)
            }
        }
        
        try modelContext.save()
        print("CSV import completed successfully")
    } catch {
        print("Error importing CSV: \(error)")
    }
}

struct WordCardView: View {
    var word: Word
    
    var body: some View {
        VStack(spacing: 20) {
            Text(word.word)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(word.translation)
                .font(.title)
                .foregroundColor(.gray)
            
            Text(word.definition)
                .font(.body)
                .padding(.horizontal)
            
            Text("Example: \(word.example)")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 5)
        .padding(.vertical, 10)
    }
}

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Word.id, order: .forward) private var words: [Word]
    @State private var hasCheckedImport = false
    
    var body: some View {
        VStack {
            if words.isEmpty {
                ProgressView()
                    .task {
                        guard !hasCheckedImport else { return }
                        hasCheckedImport = true
                        importCSV(modelContext: modelContext)
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
    }
}


// MARK: - Прев'ю для WordCardView

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
