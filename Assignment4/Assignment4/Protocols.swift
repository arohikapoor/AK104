//
//  Protocols.swift
//  Assignment4
//
//  Created by Arohi Kapoor on 7/18/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import Foundation
import UIKit

//FILE CONTAINS: enum, GridProtocol, EngineDelete Protocol, EngineProtocol

//Enum from Assignment3, incorporating feedback from Assignment3
enum CellState: String {
    
    case Living
    case Born
    case Empty
    case Died
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
    
    static func allValues() -> [CellState] { return [.Living, .Empty, .Born, .Died] }
    
    func toggle(value: CellState)-> CellState{
        
        switch value {
            case .Born, .Living:
                return .Empty
            case .Died, .Empty:
                return .Living
        }
    }
}

protocol GridProtocol {
    init(COLS: Int, ROWS: Int)
    var rows: Int { get }
    var cols: Int { get }
    func neighbors(Coordinates: (col: Int, row: Int)) -> [(col: Int, row: Int)]
    subscript(cols: Int, rows: Int) -> CellState { get set }
//    var alive:  Int { get }
//    var born:   Int { get }
//    var died:   Int { get }
//    var empty:  Int { get }
}

protocol  EngineDelegate: class {
    func engineDidUpdate(withGrid: GridProtocol)
}


// I will be setting the default value for refreshRate in its implementation as per our class discussion on not providing protocols with deault implementations and as per the discussion post on Canvas. 
protocol EngineProtocol {
    weak var delegate: EngineDelegate? { get set }
    var grid: GridProtocol { get }
    var refreshRate: Double { get set }
    var refreshTimer: NSTimer? { get set}
    var rows: Int { get set }
    var cols: Int { get set }
    init(COLS: Int, ROWS: Int)
    func step()-> GridProtocol
}





