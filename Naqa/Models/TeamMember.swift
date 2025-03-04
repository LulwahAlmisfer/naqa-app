//
//  TeamMember.swift
//  Naqa
//
//  Created by Lulwah almisfer on 01/03/2025.
//

import UIKit

struct TeamMember: Identifiable {
    let id = UUID()
    let name: LocalizedStringResource
    let role: LocalizedStringResource
    let image: String
    let linkedInURL: String
}

let teamMembers: [TeamMember] = [
    TeamMember(name: "أروى المطرفي", role: "مصممة واجهة المستخدم", image: "person3", linkedInURL: "https://www.linkedin.com/in/arwa-a-b1b85b18b/"),
    TeamMember(name: "عبدالله القحطاني", role: "Backend Developer", image: "person2", linkedInURL: "https://www.linkedin.com/in/anqahtani/"),
    TeamMember(name: "لولوه المسفر", role: "iOS Developer", image: "person1", linkedInURL: "https://www.linkedin.com/in/lulwahalmisfer/"),
]
