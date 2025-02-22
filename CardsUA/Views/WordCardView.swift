import SwiftUI
import SwiftData


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
