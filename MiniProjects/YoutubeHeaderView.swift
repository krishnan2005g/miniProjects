//
//  YoutubeHeaderView.swift
//  MiniProjects
//
//  Created by test on 12/05/25.
//

import SwiftUI

struct YoutubeHeaderView: View {

    @State var scroolOffset: CGFloat = 0
    @State var isScroolingUp: Bool = false
    @State var lastScroolOffset: CGFloat = 0
    @State var headerOffset: CGFloat = 0
    
    var body: some View {
        GeometryReader {

            let headerHeight = 60 + $0.safeAreaInsets.top

            ScrollView(.vertical) {
                LazyVStack(spacing: 16) {
                    ForEach(1...15, id: \.self) { _ in
                        DummyView()
                    }
                }
                .padding()
            }
            .safeAreaInset(edge: .top, spacing: 0) {
                HeaderView()
                    .padding(.bottom, 15)
                    .frame(height: headerHeight, alignment: .bottom)
                    .background(.background)
                    .offset(y: -headerOffset)
            }
            .ignoresSafeArea(.container, edges: .top)
            .onScrollGeometryChange(for: CGFloat.self) { proxy in
                max(min(
                    proxy.contentOffset.y + headerHeight,
                    proxy.contentSize.height - proxy.containerSize.height
                ),0)
            } action: { oldValue, newValue in
                isScroolingUp = oldValue < newValue
                headerOffset = min( max(newValue - lastScroolOffset,0) , headerHeight )
                scroolOffset = newValue
            }
            .onChange(of: isScroolingUp) { oldValue, newValue in
                lastScroolOffset = scroolOffset - headerOffset
            }
            .onScrollPhaseChange {
 oldPhase,
                newPhase in
                if !newPhase.isScrolling && (
                    headerOffset != 0 || headerOffset != headerHeight
                ) {
                    withAnimation(.snappy(duration: 0.4)) {
                        if headerOffset > (0.5 * headerHeight) && scroolOffset > headerHeight {
                            headerOffset = headerHeight
                        } else {
                            headerOffset = 0
                        }
                        
                        lastScroolOffset = scroolOffset - headerOffset
                    }
                }
            }
        }

    }

    @ViewBuilder
    func HeaderView() -> some View {
        HStack(spacing: 20) {

            HStack {
                AsyncImage(
                    url: URL(
                        string:
                            "https://upload.wikimedia.org/wikipedia/commons/thumb/0/09/YouTube_full-color_icon_%282017%29.svg/512px-YouTube_full-color_icon_%282017%29.svg.png"
                    )
                ) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    Color.clear
                }
                .frame(width: 40, height: 40)

                Text("YouTube")
                    .font(.title)
                    .fontWeight(.bold)
            }

            Spacer()

            Button("", systemImage: "airplayviedo") {

            }

            Button("", systemImage: "bell") {

            }

            Button("", systemImage: "magnifyingglass") {

            }
        }
        .font(.title2)
        .foregroundStyle(.primary)
        .padding(.horizontal)
    }

    @ViewBuilder
    func DummyView() -> some View {
        VStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 6)
                .frame(height: 220)

            HStack(spacing: 6) {
                Circle()
                    .frame(width: 44, height: 44)

                VStack(alignment: .leading, spacing: 4) {
                    Rectangle()
                        .frame(height: 10)

                    HStack(spacing: 10) {
                        Rectangle()
                            .frame(width: 100)

                        Rectangle()
                            .frame(width: 80)

                        Rectangle()
                            .frame(width: 60)
                    }
                    .frame(height: 10)
                }
            }
        }
        .foregroundStyle(.tertiary)
    }
}

#Preview {
    YoutubeHeaderView()
}
