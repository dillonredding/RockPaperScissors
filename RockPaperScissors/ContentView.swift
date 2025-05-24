import SwiftUI

struct ContentView: View {
    let rounds: Int
    let moves = ["🪨", "📄", "✂️"]

    @State private var round = 1
    @State private var score = 0
    @State private var compMoveIndex = Int.random(in: 0...2)
    @State private var shouldWin = Bool.random()
    @State private var showingAlert = false
    @State private var showingResult = false

    var alertTitle: String {
        return "\(compMove) \(correctMoveRel) \(correctMove)"
    }

    var compMove: String {
        return moves[compMoveIndex]
    }

    var correctMove: String {
        let offset = shouldWin ? 1 : 2
        return moves[(compMoveIndex + offset) % 3]
    }

    var correctMoveRel: String {
        return shouldWin ? "loses to" : "beats"
    }

    var possibleMoves: [String] {
        return moves.filter { $0 != compMove }
    }

    var prompt: String {
        let desiredResult = shouldWin ? "winning" : "losing"
        return "Make the \(desiredResult) move"
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue, .gray],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack {
                Spacer()

                HStack {
                    Spacer()
                    CaptionedTitle(caption: "Round", title: "\(round)")
                    Spacer()
                    Spacer()
                    CaptionedTitle(caption: "Score", title: "\(score)")
                    Spacer()
                }

                VStack(spacing: 20) {
                    Text(compMove)
                        .font(.system(size: 50))

                    Text(correctMoveRel)
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)

                    HStack(spacing: 40) {
                        ForEach(possibleMoves, id: \.self) { move in
                            Button(move) { make(move: move) }
                                .font(.system(size: 50))
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
                .background(.thinMaterial)
                .clipShape(.rect(cornerRadius: 20))

                Spacer()
                Spacer()
            }
            .padding()
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("Continue", action: continueGame)
            }
            .alert("Game Over", isPresented: $showingResult) {
                Button("Play again", action: resetGame)
            } message: {
                Text("You got \(score) of \(rounds) correct")
            }
        }
    }

    private func make(move: String) {
        if move == correctMove {
            score += 1
            continueGame()
        } else {
            showingAlert = true
        }
    }

    private func continueGame() {
        if round == rounds {
            showingResult = true
        } else {
            withAnimation {
                compMoveIndex = Int.random(in: 0...2)
                shouldWin.toggle()
                round += 1
            }
        }
    }

    private func resetGame() {
        withAnimation {
            compMoveIndex = Int.random(in: 0...2)
            shouldWin.toggle()
            score = 0
            round = 1
            showingResult = false
        }
    }
}

#Preview {
    ContentView(rounds: 3)
}
