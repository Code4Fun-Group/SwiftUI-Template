//
//  PlayerView.swift
//  MySampleUI
//
//  Created by Max Nguyen on 24/04/2023.
//

import SwiftUI
import ComposableArchitecture
import Common

struct PlayerView: View {
	// MARK: - Variables
	let playerOffset: Double
	let store: StoreOf<PlayerReducer>
	
	// MARK: - Body
	var body: some View {
		WithViewStore(store, observe: { $0 }) { viewStore in
			Button(action: { viewStore.send(.openOrClose) }, label: {
				VStack(alignment: .leading, spacing: 10.0) {
					if let media = viewStore.media {
						ProgressView(value: viewStore.timeValue, total: media.totalTime * 1000)
							.tint(.white)
							.background(.black)
						HStack(spacing: 8.0) {
							AsyncImage(url: media.imageThumbnailURL, scale: 1) { image in
								image
									.resizable()
									.aspectRatio(1, contentMode: .fit)
							} placeholder: {
								Image("")
									.resizable()
									.aspectRatio(1, contentMode: .fit)
							}
							.cornerRadius(4.0)
							VStack(alignment: .leading) {
								Text(media.title).multilineTextAlignment(.leading)
								Text(media.artist.name).multilineTextAlignment(.leading)
							}
							Spacer()
							Button(action: { }) {
								Text("Favorite")
							}
							Button(action: { viewStore.send(.playOrPause) }) {
								Text(viewStore.isTimerNotActive ? "Play" : "Pause")
								
							}
							Button(action: {}) {
								Text("Next")
							}
						}
						.padding([.horizontal, .bottom])
					}
				}
			})
			.fullScreenCover(isPresented: viewStore.binding(\.$isFullScreen)) {
				FullScreenPlayerView(store: store)
			}
			.background(
				LinearGradient(colors: [Color(uiColor: UIColor(hex: "#0F2027")), Color(uiColor: UIColor(hex: "#203A43")), Color(uiColor: UIColor(hex: "#2C5364"))], startPoint: .leading, endPoint: .trailing)
			)
			.frame(height: 80.0)
			.offset(y: -playerOffset)
		}
	}
}

struct PlayerView_Previews: PreviewProvider {
	static var previews: some View {
		PlayerView(playerOffset: 0.0, store: Store(initialState: PlayerReducer.State(), reducer: PlayerReducer()))
	}
}

struct UISliderView: UIViewRepresentable {
	@Binding var value: Double
	
	var minValue = 1.0
	var maxValue = 100.0
	var thumbColor: UIColor = .white
	var minTrackColor: UIColor = .blue
	var maxTrackColor: UIColor = .gray
	
	class Coordinator: NSObject {
		var value: Binding<Double>
		
		init(value: Binding<Double>) {
			self.value = value
		}
		
		@objc func valueChanged(_ sender: UISlider) {
			self.value.wrappedValue = Double(sender.value)
		}
	}
	
	func makeCoordinator() -> UISliderView.Coordinator {
		Coordinator(value: $value)
	}
	
	func makeUIView(context: Context) -> UISlider {
		let slider = UISlider(frame: .zero)
		slider.thumbTintColor = thumbColor
		slider.minimumTrackTintColor = minTrackColor
		slider.maximumTrackTintColor = maxTrackColor
		slider.minimumValue = Float(minValue)
		slider.maximumValue = Float(maxValue)
		slider.value = Float(value)
		
		slider.addTarget(
			context.coordinator,
			action: #selector(Coordinator.valueChanged(_:)),
			for: .valueChanged
		)
		
		return slider
	}
	
	func updateUIView(_ uiView: UISlider, context: Context) {
		uiView.value = Float(value)
	}
}

struct FullScreenPlayerView: View {
	let store: StoreOf<PlayerReducer>
	
	private var remainingDuration: RemainingDurationProvider<Double> {
		{ currentAngle in
			10 * (1 - (currentAngle - 0.0) / (360.0 - 0.0))
		}
	}
	
	private let animation: AnimationWithDurationProvider = { duration in
			.linear(duration: duration)
	}
	
	var body: some View {
		WithViewStore(store, observe: { $0 }, content: { viewStore in
			if let media = viewStore.media {
				VStack(spacing: 16.0) {
					// Navi
					HStack {
						Button(action: { viewStore.send(.openOrClose) }) {
							Text("Close")
						}
						Spacer()
						Button(action: { }) {
							Text("More")
						}
					}
					// Image
					AsyncImage(url: media.imageThumbnailURL, scale: 1) { image in
						image
							.resizable()
							.aspectRatio(1, contentMode: .fit)
					} placeholder: {
						Image("")
							.resizable()
							.aspectRatio(1, contentMode: .fit)
					}
					.frame(width: 300, height: 300)
					.cornerRadius(150)
					.padding()
					.rotationEffect(.degrees(viewStore.rotationDegree)).gesture(
						RotationGesture()
							.onChanged { angle in viewStore.send(.rotationValueChange(angle.degrees))
							}
					)
					.pausableAnimation(binding: viewStore.binding(\.$rotationDegree),
									   targetValue: 360.0,
									   remainingDuration: remainingDuration,
									   animation: animation,
									   paused: viewStore.binding(\.$isTimerNotActive))
					.onAppear {
						viewStore.send(.imageAnimated)
					}
					// Action
					VStack {
						// Title
						VStack {
							Text(media.title).multilineTextAlignment(.leading)
							Text(media.artist.name).multilineTextAlignment(.leading)
						}
						// Progress
						VStack {
							UISliderView(value: viewStore.binding(get: \.timeValue,
																  send: PlayerReducer.Action.sliderValueChange),
										 minValue: 0.0,
										 maxValue: media.totalTime * 1000,
										 minTrackColor: .white,
										 maxTrackColor: .blue)
							HStack {
								Text(viewStore.timeString).multilineTextAlignment(.leading)
								Spacer()
								Text(viewStore.totalTimeString).multilineTextAlignment(.leading)
							}
						}
						// Action
						HStack {
							Button(action: {}) {
								Text("Action1")
							}
							Button(action: {}) {
								Text("Previous")
							}
							Button(action: { viewStore.send(.playOrPause) }) {
								Text(viewStore.isTimerNotActive ? "Play" : "Pause")
								
							}
							Button(action: {}) {
								Text("Next")
							}
							Button(action: {}) {
								Text("Action2")
							}
						}
						Spacer()
					}
				}
				.padding()
				.onAppear { viewStore.send(.loadFullScreen) }
				.background(
					LinearGradient(colors: [Color(uiColor: UIColor(hex: "#0F2027")), Color(uiColor: UIColor(hex: "#203A43")), Color(uiColor: UIColor(hex: "#2C5364"))], startPoint: .leading, endPoint: .trailing)
				)
			}
		})
	}
}

public typealias RemainingDurationProvider<Value: VectorArithmetic> = (Value) -> TimeInterval
public typealias AnimationWithDurationProvider = (TimeInterval) -> Animation

public extension Animation {
	static let instant = Animation.linear(duration: 0.0001)
}

public struct PausableAnimationModifier<Value: VectorArithmetic>: AnimatableModifier {
	@Binding var binding: Value
	@Binding var paused: Bool
	
	private let targetValue: Value
	private let remainingDuration: RemainingDurationProvider<Value>
	private let animation: AnimationWithDurationProvider
	
	public var animatableData: Value
	
	public init(binding: Binding<Value>,
				targetValue: Value,
				remainingDuration: @escaping RemainingDurationProvider<Value>,
				animation: @escaping AnimationWithDurationProvider,
				paused: Binding<Bool>) {
		_binding = binding
		self.targetValue = targetValue
		self.remainingDuration = remainingDuration
		self.animation = animation
		_paused = paused
		animatableData = binding.wrappedValue
	}
	
	public func body(content: Content) -> some View {
		content
			.onChange(of: paused) { isPaused in
				if isPaused {
					withAnimation(.instant) {
						binding = animatableData
					}
				} else {
					withAnimation(animation(remainingDuration(animatableData))) {
						binding = targetValue
					}
				}
			}
	}
}

public extension View {
	func pausableAnimation<Value: VectorArithmetic>(binding: Binding<Value>,
													targetValue: Value,
													remainingDuration: @escaping RemainingDurationProvider<Value>,
													animation: @escaping AnimationWithDurationProvider,
													paused: Binding<Bool>) -> some View {
		self.modifier(PausableAnimationModifier(binding: binding,
												targetValue: targetValue,
												remainingDuration: remainingDuration,
												animation: animation,
												paused: paused))
	}
}
