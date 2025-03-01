//
//  TeamMember.swift
//  Naqa
//
//  Created by Lulwah almisfer on 01/03/2025.
//

import Foundation

struct TeamMember: Identifiable {
    let id = UUID()
    let name: String
    let role: String
    let image: String
    let linkedInURL: String
}

let teamMembers: [TeamMember] = [
    TeamMember(name: "أروى المطرفي", role: "مصممة واجهة المستخدم", image: "person3", linkedInURL: "https://www.linkedin.com/in/arwa-a-b1b85b18b/"),
    TeamMember(name: "عبدالله القحطاني", role: "مطور الباكيند", image: "person2", linkedInURL: "https://www.linkedin.com/in/anqahtani/"),
    TeamMember(name: "لولو المسفر", role: "مطورة التطبيق", image: "person1", linkedInURL: "https://www.linkedin.com/in/lulwahalmisfer/"),
]
