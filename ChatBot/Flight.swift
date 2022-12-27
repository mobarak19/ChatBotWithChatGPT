//
//  Flight.swift
//  ChatBot
//
//  Created by Genusys Inc on 12/21/22.
//

import Foundation

actor Flight{
    let company = "Vistara"
    var availableSeats:[String] = ["1A","1B","1C"]

    func getAvaiableSeats()->[String]{
            return availableSeats
        
    }
    func bookSeat()->String{
            let bookSeats = availableSeats.first ?? ""
            availableSeats.removeFirst()
            return bookSeats
    }
}
