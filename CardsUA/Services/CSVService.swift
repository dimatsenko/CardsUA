import SwiftUI
import SwiftData

enum CSVError: Error {
    case fileNotFound
    case invalidData
    case parsingError
}

class CSVService {
    static let shared = CSVService()
    private init() {}
    
    private func parseCSVLine(line: String) -> [String] {
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
    
    func importWords(modelContext: ModelContext) async throws {
        guard let fileUrl = Bundle.main.url(forResource: "Words", withExtension: "csv") else {
            throw CSVError.fileNotFound
        }
        
        let existingCount = try modelContext.fetchCount(FetchDescriptor<Word>())
        guard existingCount == 0 else { return }
        
        let data = try String(contentsOf: fileUrl, encoding: .utf8)
        let rows = data.components(separatedBy: .newlines)
        
        for row in rows.dropFirst() {
            let trimmed = row.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { continue }
            
            let columns = parseCSVLine(line: trimmed)
            guard columns.count >= 9 else { continue }
            
            try await processRow(columns: columns, modelContext: modelContext)
        }
        
        try modelContext.save()
    }
    
    private func processRow(columns: [String], modelContext: ModelContext) async throws {
        let cleanedColumns = columns.map {
            $0.trimmingCharacters(in: .whitespacesAndNewlines)
                .replacingOccurrences(of: "^\"|\"$", with: "", options: .regularExpression)
        }
        
        guard let id = Int(cleanedColumns[0]) else { return }
        
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
