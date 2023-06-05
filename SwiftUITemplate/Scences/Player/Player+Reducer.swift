//
//  Player+Reducer.swift
//  MySampleUI
//
//  Created by Max Nguyen on 24/04/2023.
//

import ComposableArchitecture
import Foundation

struct PlayerReducer: ReducerProtocol {
	@Dependency(\.continuousClock) var clock
	
	var body: some ReducerProtocol<State, Action> {
		BindingReducer()
		Reduce { state, action in
			switch action {
			case .loadFullScreen:
				let (hour, minute, second) = Date.getHourMinuteSecond(from: Int(state.media?.totalTime ?? 0))
				let hourStr = hour > 10 ? "\(hour)" : "0\(hour)"
				let minuteStr = minute > 10 ? "\(minute)" : "0\(minute)"
				let secondStr = second > 10 ? "\(second)" : "0\(second)"
				state.totalTimeString = "\(hourStr):\(minuteStr):\(secondStr)"
				return .none
			case .playOrPause:
				state.isTimerNotActive.toggle()
				return .run { [isTimerNotActive = state.isTimerNotActive] send in
					guard !isTimerNotActive else { return }
					for await _ in self.clock.timer(interval: .nanoseconds(1)) {
						await send(.timeUpdated, animation: .interpolatingSpring(stiffness: 3000, damping: 40))
					}
				}
				.cancellable(id: TimerID.self, cancelInFlight: true)
			case .binding:
				return .none
			case let .sliderValueChange(value):
				state.timeValue = .minimum(value, state.media?.totalTime ?? 0)
				let (hour, minute, second) = Date.getHourMinuteSecond(from: Int(state.timeValue / 1000))
				let hourStr = hour > 10 ? "\(hour)" : "0\(hour)"
				let minuteStr = minute > 10 ? "\(minute)" : "0\(minute)"
				let secondStr = second > 10 ? "\(second)" : "0\(second)"
				state.timeString = "\(hourStr):\(minuteStr):\(secondStr)"
				return .none
			case .openOrClose:
				state.isFullScreen.toggle()
				return .none
			case .timeUpdated:
				state.timeValue += 1.0
				let (hour, minute, second) = Date.getHourMinuteSecond(from: Int(state.timeValue / 1000))
				let hourStr = hour > 10 ? "\(hour)" : "0\(hour)"
				let minuteStr = minute > 10 ? "\(minute)" : "0\(minute)"
				let secondStr = second > 10 ? "\(second)" : "0\(second)"
				state.timeString = "\(hourStr):\(minuteStr):\(secondStr)"
				return .none
			case .next:
				return .none
			case .previous:
				return .none
			case let .rotationValueChange(value):
				state.rotationDegree = value
				return .none
			case .imageAnimated:
				state.rotationDegree = 0.0
				return .run { [isTimerNotActive = state.isTimerNotActive] send in
					guard !isTimerNotActive else { return }
					await send(.rotationValueChange(360.0), animation: .linear(duration: 10))
				}
				.cancellable(id: ImageAnimationID.self, cancelInFlight: true)
			}
		}
	}
}

extension PlayerReducer {
	struct State: Equatable {
		@BindingState var isTimerNotActive = true
		@BindingState var rotationDegree = 0.0
		@BindingState var isFullScreen = false
		@BindingState var timeValue = 0.0
		var timeString: String = "00:00:00"
		var totalTimeString: String = "00:00:00"
		var media: MediaModel? = MediaModel(imageThumbnailURL: URL(string: "https://picsum.photos/200"), totalTime: 240.0, title: "Test", artist: ArtistModel(name: "Test test"))
	}
}

extension PlayerReducer {
	enum Action: BindableAction {
		case loadFullScreen
		case playOrPause
		case binding(BindingAction<State>)
		case sliderValueChange(Double)
		case openOrClose
		case timeUpdated
		case next
		case previous
		case rotationValueChange(Double)
		case imageAnimated
	}
}

extension PlayerReducer {
	private enum TimerID {}
	private enum ImageAnimationID {}
}

struct MediaModel: Equatable {
	var imageThumbnailURL: URL?
	var totalTime: Double
	var title: String
	var artist: ArtistModel
}

struct ArtistModel: Equatable {
	var name: String
}
