import SwiftUI

struct CaptionedTitle: View {
    var caption: String
    var title: String

    var body: some View {
        VStack {
            Text(caption)
                .font(.caption)
            Text(title)
                .font(.title)
        }
        .foregroundStyle(.white)
    }
}
