import SwiftUI
import SwiftData


struct WordCardView: View {
    let word: Word
   
    
    var body: some View {
        VStack(spacing: 0) {
            headerView
            Spacer()
            mainContentView
            Spacer()
            footerView
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 5)
        .padding(.vertical, 10)
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("new word")
                    .font(.system(size: 24, weight: .semibold))
                Text("CEFR - \(word.cefr.uppercased())")

                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
    
    // MARK: - Main Content View
    private var mainContentView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                HStack(alignment: .firstTextBaseline) {
                    Text(word.word)
                        .font(.system(size: 36, weight: .bold))
                    Text("(\(word.type))")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                    Spacer()
                }
                HStack {
                    Text(word.phon_n_am)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.gray)
                    Spacer()
                }
            }
            // Кнопка відтворення (передбачено додавання дії)
            Button(action: {
            }) {
                Image(systemName: "play")
                    .font(.system(size: 36, weight: .semibold))
                    .foregroundColor(.black)
            }
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - Footer View
    private var footerView: some View {
        HStack {
            Button(action: {
                // Додайте дію для "ЗНАЮ"
            }) {
                Text("знаю")
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
            }
            
            Divider()
                .frame(height: 24)
                .background(Color.gray)
            
            Button(action: {
                // Додайте дію для "ВЧИТИ"
            }) {
                Text("вчити")
                    .font(.system(size: 24))
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.gray)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 20)
    }
    
    private var reversedCardView: some View {
        HStack {
            
        }
    }
    
 
}


