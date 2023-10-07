![CleanShot 2023-10-06 at 11  12 12](https://github.com/muukii/swiftui-touch-slider/assets/1888355/5bfc5c43-2b64-4238-ae6a-b20f1b949b5d)


```swift
@State var value: Double = 0

...

TouchSlider(
  direction: .horizontal,
  value: $touchSlider_value,
  speed: 1, // multiplier to track gesture translation.
  foregroundColor: Color.red,
  backgroundColor: Color(white: 0.5, opacity: 0.3),
  cornerRadius: 16
)
.frame(height: 80)
```
