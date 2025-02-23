import SwiftUI
import SwiftData

struct DictionaryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var levels: [Level]
    
    var body: some View {
        List {
            ForEach(levels) { level in
                HStack {
                    Text(level.name)
                    Spacer()
                    Toggle("", isOn: Binding(
                        get: { level.isSelected },
                        set: { newValue in
                            level.isSelected = newValue
                        }
                    ))
                    .labelsHidden()
                }
            }
        }
        .navigationTitle("Dictionary")
        .onAppear {
            if levels.isEmpty {
                // Add default levels if none exist
                let defaultLevels = ["a1", "a2", "b1", "b2", "c1"]
                for levelName in defaultLevels {
                    let level = Level(name: levelName)
                    modelContext.insert(level)
                }
            }
        }
    }
}

