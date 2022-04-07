import SwiftUI

enum SheetPosition: CGFloat, CaseIterable {
    case collapsed = 0.1    // 10% of screen height
    case mid = 0.5         // 50% of screen height
    case expanded = 0.85   // 85% of screen height
}

struct BottomSheetView<Content: View>: View {
    let content: Content
    @Binding var position: SheetPosition
    @GestureState private var translation: CGFloat = 0
    @State private var predictedEndPosition: SheetPosition = .mid
    
    init(position: Binding<SheetPosition>, @ViewBuilder content: () -> Content) {
        self._position = position
        self.content = content()
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Handle
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 36, height: 5)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                
                content
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.background)
                    .shadow(radius: 5)
            )
            .frame(height: geometry.size.height, alignment: .bottom)
            .offset(y: max(0, translation + position.rawValue * geometry.size.height))
            .animation(.interpolatingSpring(stiffness: 300.0, damping: 30.0, initialVelocity: 10.0), value: position)
            .gesture(
                DragGesture()
                    .updating($translation) { value, state, _ in
                        state = value.translation.height
                    }
                    .onChanged { value in
                        let offsetY = value.translation.height
                        let currentHeight = position.rawValue * geometry.size.height
                        let predictedHeight = currentHeight + offsetY
                        let predictedPercentage = predictedHeight / geometry.size.height
                        
                        predictedEndPosition = SheetPosition.allCases
                            .min { abs($0.rawValue - predictedPercentage) < abs($1.rawValue - predictedPercentage) } ?? .mid
                    }
                    .onEnded { value in
                        position = predictedEndPosition
                    }
            )
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        BottomSheetView(position: .constant(.mid)) {
            Color.white
        }
    }
} 