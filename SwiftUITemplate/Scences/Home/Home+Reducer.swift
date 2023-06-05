//
//  HomeBinding.swift
//  MySampleUI
//
//  Created by Max Nguyen on 23/04/2023.
//

import ComposableArchitecture
import Networking
import Foundation

struct HomeReducer: ReducerProtocol {
	@Dependency(\.mobileBFFAPIService) var mobileBFFAPIService
	
	var body: some ReducerProtocol<State, Action> {
		Reduce { state, action in
			switch action {
			case .loadScreen:
				state.isActivityIndicatorVisible = true
				state.response = nil
				state.error = nil
				state.banners = [
					BannerModel(id: UUID(), title: "Test 1"),
					BannerModel(id: UUID(), title: "Test 2"),
					BannerModel(id: UUID(), title: "Test 3"),
					BannerModel(id: UUID(), title: "Test 4")
				]
				return getSomeThingsEffectTask()
			case let .apiResponse(.success(response)):
				state.isActivityIndicatorVisible = false
				state.response = response
				return .none
			case let .apiResponse(.failure(error)):
				state.isActivityIndicatorVisible = false
				state.error = error.localizedDescription
				return .none
			case let .setNavigation(.some(id)):
				state.selection = Identified(
					AlbumReducer.State(bannerModel: state.banners.first(where: { $0.id == id })),
					id: id
				)
				return .none
			case .setNavigation(selection: .none):
				state.selection = nil
				return .none
			case .selectedBanner:
				return .none
			}
		}.ifLet(\.selection, action: /Action.selectedBanner) {
			Scope(state: \Identified<BannerModel.ID, AlbumReducer.State>.value, action: /.self) {
				AlbumReducer()
			}
		}
	}
}

extension HomeReducer {
	struct State: Equatable {
		var banners: IdentifiedArrayOf<BannerModel> = []
		var isActivityIndicatorVisible = false
		var response: SampleResponse?
		var selection: Identified<BannerModel.ID, AlbumReducer.State>?
		var error: String?
	}
}

extension HomeReducer {
	enum Action {
		case loadScreen
		case apiResponse(Result<SampleResponse?, Error>)
		case selectedBanner(AlbumReducer.Action)
		case setNavigation(selection: UUID?)
	}
}

struct SampleResponse: Codable, Equatable {
	var message: String?
	var status: String?
}

extension HomeReducer {
	func getSomeThingsEffectTask() -> EffectTask<Action> {
		return .task {
			let result = try await mobileBFFAPIService.fetch(request: .getSomeThings)
			switch result {
			case .success(let data):
				return .apiResponse(await JSONDataHandler().handle(jsonData: data))
			case .failure(let error):
				return .apiResponse(.failure(error))
			}
		}
	}
}

struct BannerModel: Equatable, Identifiable {
	let id: UUID
	var title: String?
}
