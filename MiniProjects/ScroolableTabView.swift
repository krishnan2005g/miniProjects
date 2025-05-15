//
//  ScroolableTabView.swift
//  MiniProjects
//
//  Created by test on 06/05/25.
//

import SwiftUI

struct ScroolableTabView: View {
    
    @State private var tabProgress: CGFloat = 0
    @State var seletedTab: Tab?
    @Environment(\.colorScheme) private var scheme
    
    
    var body: some View {
        VStack (spacing: 15){
            HStack{
                Button(action: {
                    
                }) {
                    Image(systemName: "line.3.horizontal.decrease")
                }
                Spacer()
                Button(action: {
                    
                }) {
                    Image(systemName: "bell.badge")
                }
            }
            .font(.title2)
            .overlay {
                Text("Messages")
                    .font(.title3.bold())
            }
            .foregroundStyle(.primary)
            .padding(14)
            
            CustomTabView()
            
            GeometryReader {
                let size  = $0.size
                
                ScrollView(.horizontal){
                    LazyHStack(spacing: 0){
                        SampleView(.red)
                            .id(Tab.messages)
                            .containerRelativeFrame(.horizontal)
                        
                        SampleView(.green)
                            .id(Tab.calls)
                            .containerRelativeFrame(.horizontal)
                        
                        SampleView(.pink)
                            .id(Tab.settings)
                            .containerRelativeFrame(.horizontal)
                    }
                    .scrollTargetLayout()
                    .offsetX { value in
                        let progress = -value / (size.width * CGFloat(Tab.allCases.count - 1))
                        tabProgress = max(min(progress,1),0)
                    }
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $seletedTab)
                .scrollIndicators(.hidden)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.gray.opacity(0.1))
    }
    
    
    @ViewBuilder
    func CustomTabView() -> some View {
        HStack(spacing: 6) {
            ForEach(Tab.allCases, id: \.self) { tab in
                HStack{
                    Image(systemName: tab.systemImage)
                    
                    Text(tab.rawValue)
                        .font(.callout)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .contentShape(.capsule)
                .onTapGesture {
                    withAnimation(.snappy) {
                        seletedTab = tab
                    }
                }
            }
        }
        .tabMask(tabProgress)
        .background {
            GeometryReader {
                let size = $0.size
                let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                
                Capsule()
                    .fill(scheme == .dark ? .black : .white)
                    .frame(width: capsuleWidth)
                    .offset(x: tabProgress * (size.width - capsuleWidth))
            }
        }
        .background(.gray.opacity(0.1), in: .capsule)
        .padding(.horizontal)
    }
    
    
    @ViewBuilder
    func SampleView(_ color: Color) -> some View {
        ScrollView(.vertical){
            LazyVGrid(columns: Array(repeating: GridItem(), count: 2)) {
                ForEach(1...10, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 14)
                        .fill(color.gradient)
                        .frame(height: 160)
                        .overlay {
                            VStack(alignment: .leading) {
                                Circle()
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 50, height: 50)
                                
                                VStack(alignment: .leading){
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 80, height: 8)
                                    
                                    RoundedRectangle(cornerRadius: 6)
                                        .fill(.white.opacity(0.25))
                                        .frame(width: 60, height: 8)
                                }
                                
                                Spacer()
                                
                                RoundedRectangle(cornerRadius: 6)
                                    .fill(.white.opacity(0.25))
                                    .frame(width: 40, height: 8)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                }
            }
            .padding(16)
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .mask {
            Rectangle()
                .padding(.bottom, -100)
        }
    }
    
    
}

#Preview {
    ScroolableTabView(seletedTab: .messages)
}


enum Tab:String, CaseIterable {
    
    case messages = "Message"
    case calls = "Calls"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .messages:
            return "message"
        case .calls:
            return "phone"
        case .settings:
            return "gear"
        }
    }
}



//Helper
struct OffSetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat ) {
        value = nextValue()
    }
}


extension View {
    
    @ViewBuilder
    func offsetX(completion: @escaping (CGFloat) -> ()) -> some View{
        self
            .overlay {
                GeometryReader{
                    let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                    
                    Color.clear
                        .preference(key: OffSetKey.self, value: minX)
                        .onPreferenceChange(OffSetKey.self,perform: completion)
                }
            }
    }
    
    @ViewBuilder
    func tabMask(_ tabProgress: CGFloat) -> some View {
        ZStack{
            self
                .foregroundStyle(.gray)
            
            self
                .symbolVariant(.fill)
                .mask {
                    GeometryReader {
                        let size = $0.size
                        let capsuleWidth = size.width / CGFloat(Tab.allCases.count)
                        
                        
                        Capsule()
                            .frame(width: capsuleWidth)
                            .offset(x: tabProgress * (size.width - capsuleWidth))
                    }
                }
        }
    }
}
