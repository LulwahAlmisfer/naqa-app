//
//  SettingsView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 28/02/2025.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.layoutDirection) private var layoutDirection
    @Environment(\.colorScheme) var colorScheme
    @State private var showIconInToolbar = false
    

    
    var body: some View {
        NavigationView {
            
            
            GeometryReader { geometry in
                Form {
                    
                    icon
                        .frame(maxWidth: .infinity)
                        .background(Color(uiColor: colorScheme == .light ? UIColor.secondarySystemBackground : UIColor.black))
                        .listRowBackground(Color.clear)
                        .opacity(showIconInToolbar ? 0.01 : 1)

                    naqaInfo
                    team
                    
                    dataSource
                    supervision
                    changeLanguage
                    ehsan
                }
                .onChange(of: geometry.frame(in: .global).minY) { oldValue, newValue in
                    if newValue < 110 {
                        withAnimation(Animation.default.delay(0.4)) { showIconInToolbar = true }
                    } else {
                        withAnimation(Animation.default.delay(0.2)) { showIconInToolbar = false }
                    }
                    
                }
            }
            .scrollIndicators(.hidden)
            .navigationTitle("عن نقاء")
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    if showIconInToolbar {
                        icon
                    }
                }
            }
        }
        
        
    }
    
    
    
    var changeLanguage: some View {
        Button{
            Helper.goToAppSetting()
        }label: {
            HStack {
                Text("Change Language")
                Spacer()
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
                .frame(width: showIconInToolbar ? 25 : 100,height: showIconInToolbar ? 25 : 100)
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
            Text("نقاء هو حاسبة تطهير الأسهم تساعد المستثمرين على حساب المبالغ الواجب تطهيرها وفقًا للضوابط الشرعية. يتيح لك التطبيق إدخال بيانات استثمارك بسهولة والحصول على النتائج بسهولة.")
        }
        .textCase(nil)
        
    }
    
    var ehsan: some View {
        Link(destination: URL(string: "https://ehsan.sa/stockspurification")!) {
            HStack {
                Image("ehsan")
                    .resizable()
                    .renderingMode(.none)
                    .frame(width: 35,height: 35)
                Text("تبرع بخدمة إحسان لتطهير الأسهم")
                Spacer()
                Image(systemName: "chevron.left")
                    .rotationEffect(layoutDirection == .leftToRight ? Angle(degrees: 180) : Angle(degrees: 0))
            }
        }
    }
    
    var dataSource: some View {
        Section(header: Text("مصدر البيانات")) {
            VStack(alignment: .leading, spacing: 8) {
                Text("هذه الخدمة مبنية على قوائم التطهير المنشورة للعامة من قبل فضيلة الشيخ الدكتور محمد بن سعود العصيمي (المشرف العام على موقع المقاصد). تم جمع وتنظيم البيانات من:")
                
                VStack(alignment: .leading, spacing: 8) {
                    bulletPointView("حاسبة التطهير - موقع المقاصد")
                    bulletPointView("قوائم التحليل المالي للشركات المنشورة للعامة")
                    bulletPointView("حسابات نسب التطهير المعتمدة من قبل الشيخ د. محمد العصيمي")
                }
                .font(.footnote)
                .foregroundColor(.gray)
            }
        }
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
    }
    
    @ViewBuilder
    func bulletPointView(_ text: String) -> some View {
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
