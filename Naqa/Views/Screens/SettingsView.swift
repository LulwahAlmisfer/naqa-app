//
//  SettingsView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 28/02/2025.
//

import SwiftUI
import PostHog

struct SettingsView: View {
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.colorScheme) var colorScheme
    @State private var showIconInToolbar = false
    @State private var showIcon = true
    
    
    var body: some View {
        NavigationView {
            
            
            GeometryReader { geometry in
                Form {
                    
                    icon
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: colorScheme == .light ? UIColor.secondarySystemBackground : UIColor.black))
                        .listRowBackground(Color.clear)
                        .opacity(showIcon ? 1 : 0)
                        .transition(.opacity)

                    naqaInfo
                    team
                    
                    dataSource
                    if PostHogSDK.shared.isFeatureEnabled("EHSAN") {
                        ehsan
                    }
                    rate
//                    supervision
                    changeLanguage
                  
                }
                .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
                    if newValue < 110 {
                        withAnimation(Animation.default.delay(0.2)) { showIcon = false }
                    } else {
                        withAnimation(Animation.default.delay(0.2)) { showIcon = true }
                    }
                    
                    
                    if newValue < 115 {
                        withAnimation(Animation.default.delay(0.2)) { showIconInToolbar = true }
                    } else {
                        withAnimation(Animation.default.delay(0.2)) { showIconInToolbar = false }
                    }
                    
                }
            }
            .logEvent("SettingsView_Opened")
            .scrollIndicators(.hidden)
            .navigationTitle("عن نقاء")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                        iconToolBar
                            .transition(.opacity)
                            .opacity(showIconInToolbar ? 1 : 0)
                }
            }
        }
        
        
    }
    
    var rate: some View {
        
        Link(destination:  URL(string: "https://apps.apple.com/app/id6742379470?action=write-review")!) {
            HStack {
                Image(systemName: "star.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.naqaLightPurple)
                
                Text("rating")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.left")
                    .rotationEffect(layoutDirection == .leftToRight ? Angle(degrees: 180) : Angle(degrees: 0))
            }
        }
    }
    
    var ehsan: some View {
        Link(destination: URL(string: "https://ehsan.sa/stockspurification")!) {
            HStack {
                Image("ehsan")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .background(.white)
                    .clipShape(.circle)

                Text("تبرع بخدمة إحسان لتطهير الأسهم")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.left")
                    .rotationEffect(layoutDirection == .leftToRight ? Angle(degrees: 180) : Angle(degrees: 0))
            }
        }.onTapGesture {
            PostHogSDK.shared.capture("CLICKED_DONATE_EHSAN")
        }
    }
    

    var changeLanguage: some View {
        Button {
            Helper.goToAppSetting()
        } label: {
            HStack {
                Image(systemName: "globe")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20) // Ensuring consistency
                    .foregroundStyle(.naqaLightPurple)
                
                Text("Change Language")
                    .foregroundStyle(colorScheme == .dark ? .white : .black)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                
                Image(systemName: "chevron.left")
                    .rotationEffect(layoutDirection == .leftToRight ? Angle(degrees: 180) : Angle(degrees: 0))
            }
        }
    }

    
    var icon: some View {
        HStack {
            Spacer()
            Image(.naqaIcon)
                .resizable()
                .frame(width:  100,height: 100)
            Spacer()
        }
        .padding()
    }
    
    var iconToolBar: some View {
        HStack {
            Spacer()
            Image(.naqaIcon)
                .resizable()
                .frame(width: 25 ,height: 25)
            Spacer()
        }
        .padding()
    }
    
    var team: some View {
        Section("Naqaa Team") {
            ForEach(teamMembers) { member in
                HStack {
                    
                    
                    Image(systemName: "person")
                        .foregroundStyle(.white)
                        .padding(8)
                        .background(.naqaLightPurple)
                        .clipShape(Circle())
                    
                    
                    VStack(alignment: .leading) {
                        Text(member.name)
                            .font(.headline)
                        Text(member.role)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    Spacer()
                    
                    Link(destination: URL(string: member.linkedInURL)!) {
                        Image(systemName: "chevron.left")
                            .rotationEffect(layoutDirection == .leftToRight ? Angle(degrees: 180) : Angle(degrees: 0))
                    }
                }
            }
        }
        .textCase(nil)
    }
    
    var naqaInfo: some View {
        Section("What is Naqa ?") {
            Text("NAQA_DEF")
        }
        .textCase(nil)
        
    }
    
    var dataSource: some View {
        Section(header: Text("مصدر البيانات")) {
            VStack(alignment: .leading, spacing: 8) {
                Text("هذه الخدمة مبنية على قوائم التطهير المنشورة للعامة من قبل فضيلة الشيخ الدكتور محمد بن سعود العصيمي (المشرف العام على موقع المقاصد). تم جمع وتنظيم البيانات من:")
                
                VStack(alignment: .leading, spacing: 8) {
                    bulletPointView("موقع المقاصد")
                    bulletPointView("قوائم التحليل المالي للشركات المنشورة للعامة")
                    bulletPointView("حسابات نسب التطهير المعتمدة من قبل الشيخ د. محمد العصيمي")
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }
        }
        .textCase(nil)

    }

    var supervision: some View {
        Section(header: Text("الاعتماد والإشراف")) {
            VStack(alignment: .leading, spacing: 8) {
                Text("فضيلة الشيخ الدكتور محمد بن سعود العصيمي")
                Text("المشرف العام على موقع المقاصد للاقتصاد الإسلامي")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
        }
        .textCase(nil)
    }
    
    @ViewBuilder
    func bulletPointView(_ text: LocalizedStringResource) -> some View {
        HStack(alignment: .top, spacing: 6) {
            Circle()
                .fill(Color.naqaLightPurple)
                .frame(width: 6, height: 6)
                .offset(y: 6)
            Text(text)
        }
    }

}

#Preview {
    SettingsView()
}
