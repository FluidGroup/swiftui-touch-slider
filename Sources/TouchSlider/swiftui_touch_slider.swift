import SwiftUI

public struct TouchSlider: View {

  private struct TrackingState: Equatable {
    let beginProgress: Double
  }

  var isTracking: Bool {
    trackingState != nil
  }

  @GestureState private var trackingState: TrackingState? = nil

  @Binding var progress: Double
  public let speed: Double
  public let direction: Axis

  private let foregroundColor: Color
  private let backgroundColor: Color
  private let cornerRadius: Double

  public init(
    direction: Axis,
    value: Binding<Double>,
    speed: Double = 1,
    foregroundColor: Color = Color(white: 0.5, opacity: 0.5),
    backgroundColor: Color = Color(white: 0.5, opacity: 0.5),
    cornerRadius: Double = .greatestFiniteMagnitude
  ) {
    self._progress = value
    self.direction = direction
    self.speed = speed
    self.foregroundColor = foregroundColor
    self.backgroundColor = backgroundColor
    self.cornerRadius = cornerRadius
  }

  public var body: some View {

    GeometryReader { proxy in
      ZStack {

        backgroundColor

        switch direction {
        case .horizontal:
          HStack {
            foregroundColor
              .frame(width: proxy.size.width * max(min(1, progress), 0))
            Spacer(minLength: 0)
          }

        case .vertical:
          VStack {
            Spacer(minLength: 0)
            foregroundColor
              .frame(height: proxy.size.height * max(min(1, progress), 0))
          }

        }

      }
      .clipShape(
        RoundedRectangle(
          cornerRadius: cornerRadius,
          style: .continuous
        )
        .inset(by: { if isTracking { 0 } else { 4 }}())
      )
      .animation(.bouncy, value: isTracking)
      .animation(.bouncy, value: { () -> Double in
        if isTracking {
          return 0
        } else {
          return progress
        }
      }())
      .gesture(
        DragGesture(minimumDistance: 0)
          .updating(
            $trackingState,
            body: { value, trackingState, transaction in

              if trackingState == nil {
                trackingState = .init(
                  beginProgress: progress
                )

                UIImpactFeedbackGenerator(style: .light).impactOccurred()
              }
            }
          )
          .onChanged({ value in

            guard let trackingState else {
              return
            }

            let constantSpeedProgress = {
              switch direction {
              case .horizontal:
                value.translation.width / proxy.size.width
              case .vertical:
                -value.translation.height / proxy.size.height
              }
            }()

            let progressChanges = constantSpeedProgress * speed

            progress = max(min(1, trackingState.beginProgress + progressChanges), 0)

          })
          .onEnded { _ in
            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
          }
      )
    }
    .frame(minWidth: 4, minHeight: 4)

  }

}
