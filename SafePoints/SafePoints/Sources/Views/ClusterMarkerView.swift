import SwiftUI

struct ClusterMarkerView: View {
    let count: Int
    let title: String
    
    var body: some View {
        VStack(spacing: 4) {
            // Circle with count
            ZStack {
                Circle()
                    .fill(Color.red)
                    .frame(width: 40, height: 40)
                    .shadow(radius: 2)
                
                Text("\(count)")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
            }
            
            // Title below circle
            if !title.isEmpty {
                Text(title)
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                    .lineLimit(1)
                    .padding(.horizontal, 4)
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(4)
            }
        }
    }
}

#Preview {
    ClusterMarkerView(count: 86, title: "Lisbon")
}
