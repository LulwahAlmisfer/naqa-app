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

    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                
                icon
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: colorScheme == .light ? UIColor.secondarySystemBackground : UIColor.black))
                
                Form {
                    
                    naqaInfo
                    team
                    
                    Text("todo about almaqased")

                    changeLanguage
                    ehsan
                                    
                    
                }
                .navigationTitle("عن نقاء")
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
                .frame(width: 100,height: 100)
            Spacer()
        }.padding()
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
            Text("نقاء هو حاسبة تطهير الأسهم تساعد المستثمرين على حساب المبالغ الواجب تطهيرها وفقًا للضوابط الشرعية. يتيح لك التطبيق إدخال بيانات استثمارك بسهولة والحصول على النتائج بسرعة. محتوى مبدئي احتاج مساعده")
        }
        .textCase(nil)
            
    }
    
    var ehsan: some View {
        Link(destination: URL(string: "https://ehsan.sa/stockspurification")!) {
            HStack {
                Text("تبرع بخدمة إحسان لتطهير الأسهم")
                Spacer()
                Image("ehsan")
                    .resizable()
                    .renderingMode(.none)
                    .frame(width: 35,height: 35)
            }
        }
    }
}

#Preview {
    SettingsView()
}
