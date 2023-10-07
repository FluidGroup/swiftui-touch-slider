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

extension Color {

  static var vibrantBlue: Color {
    // #0600FF
    Color(.displayP3, red: 0.023529411764705882, green: 0.0, blue: 1.0, opacity: 1)
  }

  static var vibrantOrange: Color {
    // #FF7A00
    Color(.displayP3, red: 1.0, green: 0.47843137254901963, blue: 0.0, opacity: 1)
  }

  static var vibrantRed: Color {
    // #FF3D00
    Color(.displayP3, red: 1.0, green: 0.23921568627450981, blue: 0.0, opacity: 1)
  }

  static var vibrantPurple: Color {
    // #8F00FF
    Color(.displayP3, red: 0.5607843137254902, green: 0.0, blue: 1.0, opacity: 1)
  }

  static var vibrantYellow: Color {
    // #FFA800
    Color(.displayP3, red: 1.0, green: 0.6588235294117647, blue: 0.0, opacity: 1)
  }

  static var vibrantPink: Color {
    // #ED0047
    Color(.displayP3, red: 0.9294117647058824, green: 0.0, blue: 0.2784313725490196, opacity: 1)
  }

  static var vibrantGreen: Color {
    // #00E124
    Color(.displayP3, red: 0.0, green: 0.8823529411764706, blue: 0.1411764705882353, opacity: 1)
  }

}

#if DEBUG
struct BookSlider: View {

  @State var slider_value: Double = 102
  @State var touchSlider_value: Double = 0

  var body: some View {

    VStack {

      Spacer()

      VStack {
        VStack {
          TouchSlider(
            direction: .horizontal,
            value: $touchSlider_value,
            speed: 1,
            foregroundColor: Color.vibrantBlue,
            backgroundColor: Color(white: 0.5, opacity: 0.3)
          )
          .frame(height: 20)

          TouchSlider(
            direction: .horizontal,
            value: $touchSlider_value,
            speed: 1,
            foregroundColor: Color.vibrantPink,
            backgroundColor: Color(white: 0.5, opacity: 0.3),
            cornerRadius: 16
          )
          .frame(height: 40)

          TouchSlider(
            direction: .horizontal,
            value: $touchSlider_value,
            speed: 1,
            foregroundColor: Color.vibrantRed,
            backgroundColor: Color(white: 0.5, opacity: 0.3),
            cornerRadius: 16
          )
          .frame(height: 80)
        }
        .frame(maxHeight: .infinity)

        HStack(spacing: 20) {
          TouchSlider(
            direction: .vertical,
            value: $touchSlider_value,
            speed: 1,
            foregroundColor: Color.vibrantPink,
            backgroundColor: Color(white: 0.5, opacity: 0.3)
          )
          .frame(width: 20)

          TouchSlider(
            direction: .vertical,
            value: $touchSlider_value,
            speed: 1,
            foregroundColor: Color.vibrantPurple,
            backgroundColor: Color(white: 0.5, opacity: 0.3),
            cornerRadius: 16
          )
          .frame(width: 40)

          TouchSlider(
            direction: .vertical,
            value: $touchSlider_value,
            speed: 1,
            foregroundColor: Color.vibrantYellow,
            backgroundColor: Color(white: 0.5, opacity: 0.3),
            cornerRadius: 16
          )
          .frame(width: 80)
        }
        .frame(maxHeight: .infinity)
      }
      .padding(.horizontal)

    }
    .onAppear {
    }
  }
}

#Preview {
  BookSlider()
}
#endif
