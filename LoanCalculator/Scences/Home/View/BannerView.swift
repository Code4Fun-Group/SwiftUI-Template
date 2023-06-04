//
//  BannerView.swift
//  MySampleUI
//
//  Created by Max Nguyen on 25/04/2023.
//

import SwiftUI
import Common

struct BannerView: View {
	let bannerViewModel: BannerViewModel
	
	var body: some View {
		AsyncImage(url: bannerViewModel.imageThumbnailURL) { image in
			image
				.resizable()
				.aspectRatio(1, contentMode: .fill)
		} placeholder: {
			Rectangle()
				.background(.green)
		}
		.overlay(alignment: .bottomLeading, content: {
			VStack(alignment: .leading) {
				Text(bannerViewModel.title).foregroundColor(.red).multilineTextAlignment(.leading)
				Text(bannerViewModel.artistName).foregroundColor(.red).multilineTextAlignment(.leading)
			}
		})
		.frame(width: SystemInfo.screenWidth / 1.5, height: 150)
		.cornerRadius(4.0)
	}
}

struct BannerView_Previews: PreviewProvider {
	static var previews: some View {
		BannerView(bannerViewModel: BannerViewModel())
	}
}

struct BannerViewModel {
	var imageThumbnailURL: URL?
	var title: String
	var artistName: String
}

extension BannerViewModel {
	init() {
		imageThumbnailURL = URL(string: "https://picsum.photos/200")
		title = "Test"
		artistName = "Test Test"
	}
}
