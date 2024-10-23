//
//  HeaderView.swift
//  TODO50
//
//  Created by Julius Pleunes on 17/10/2024.
//

import SwiftUI

struct HeaderView: View { // header elements
    let title: String
    let subtitle: String
    let angle: Double
    let background: Color
    
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0) // creates rectangular background with sharp corners
                .foregroundColor(background) // applies background color
                .rotationEffect(Angle(degrees: angle)) // rotates background by specified angle
           //   .offset(y: -40)
            
            VStack {
                Text(title) // display title
                    .font(.system(size: 50)) // sets font size of title
                    .foregroundColor(Color.white) // color of title
                    .bold() // makes title bold (fat)
                
                Text(subtitle) // display subtitle
                    .font(.system(size: 20)) // sets font size
                    .foregroundColor(Color.white) // color of subtitle
            }
            .padding(.top, 80) // creates space
        }
        .frame(width: UIScreen.main.bounds.width * 3, height: 350) // sets the frame width and height of the header
        .offset(y: -150) // offsets the header (vertically) by -150
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(title: "Title",
                   subtitle: "Subtitle",
                   angle: 15,
                   background: .blue) // provides sample data for preview
    }
}
