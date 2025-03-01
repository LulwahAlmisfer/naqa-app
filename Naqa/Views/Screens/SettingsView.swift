//
//  SettingsView.swift
//  Naqa
//
//  Created by Lulwah almisfer on 28/02/2025.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView {
            VStack(spacing: 0){
                
                icon
                    .frame(maxWidth: .infinity)
                    .background(Color(uiColor: UIColor.secondarySystemBackground))
                
                Form {
                    
                    naqaInfo
                    team
                    
                    Button("Change Language") {
                        Helper.goToAppSetting()
                    }
                    Text("todo about almaqased")
                    Text("todo team")
                    Text("todo ehsan link")
                    
                    
                    
                }
                .navigationTitle("عن نقاء")
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
                          Image(systemName: "chevron.right")
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
}

#Preview {
    SettingsView()
}
