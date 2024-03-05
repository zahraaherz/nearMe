//
//  String+Extention .swift
//  NearMe
//
//  Created by Zahraa Herz on 21/09/2023.
//

import Foundation

extension String {
    
    var formatPhoneCall: String{
        self.replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "+", with: "")
            .replacingOccurrences(of: "(", with: "")
            .replacingOccurrences(of: ")", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
