//
//  EngineSupport.swift
//  Final
//
//  Created by Arohi Kapoor on 8/4/16.
//  Copyright © 2016 Arohi Kapoor. All rights reserved.
//

import Foundation

//This file contains enum and protocols
enum CellState: String {
    case Empty
    case Died
    case Born
    case Alive
    
    func isLiving() -> Bool {
        switch self {
        case .Alive, .Born: return true
        case .Died, .Empty: return false
        }
    }
    
    func toggle(value: CellState)-> CellState{
        
        switch value {
        case .Born, .Alive:
            return .Empty
        case .Died, .Empty:
            return .Alive
        }
    }
}

protocol GridProtocol {
    init(COLS: Int, ROWS: Int)
    var rows: Int { get }
    var cols: Int { get }
    func neighbors(Coordinates: (col: Int, row: Int)) -> [(col: Int, row: Int)]
    subscript(cols: Int, rows: Int) -> CellState { get set }
    var states:[CellState: Int] { get }
    //    var alive:  Int { get }
    //    var born:   Int { get }
    //    var died:   Int { get }
    //    var empty:  Int { get }
}

//I will set the default value for refreshRate in its implementation
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

protocol  EngineDelegate: class {
    func engineDidUpdate(withGrid: GridProtocol)
}

