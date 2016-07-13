//
//  Enum.swift
//  Assignment3
//
//  Created by Arohi Kapoor on 7/11/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import Foundation

//I put the enum in a separate file because I wasn't sure where else to put it
enum CellState: String {
    
    case Living = "living"
    case Born = "born"
    case Empty = "empty"
    case Died = "died"
    
    func description() -> String{
        switch self{
        case .Living:
            return CellState.Living.rawValue
        case .Born:
            return CellState.Born.rawValue
        case .Empty:
            return CellState.Empty.rawValue
        case .Died:
            return CellState.Died.rawValue
        }
    }
    
    
    func allValues() -> [CellState]{
        return [CellState.Living,CellState.Born, CellState.Died, CellState.Empty]
    }
    
    func toggle(value: CellState)-> CellState{
        switch value {
            
        case .Living:
            return .Empty
        case .Born:
            return .Empty
        case .Empty:
            return .Living
        case .Died:
            return .Living
        }
    }
    
}