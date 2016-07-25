//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func isLeap(year: Int) -> Bool { return (year%4 == 0 && (year%100 != 0 ? true : (year%100 == 0 && year%400 == 0 ? true : false ))) ? true : false }

func julianDate(year: Int, month: Int, day: Int) -> Int {
    let first : Int = 693901
    let X = (month: ((month + 9) % 12), year: (year - ((month + 9) % 12)/10))
    return  ((365*X.year) + (X.year/4) - (X.year/100) + (X.year/400) + (X.month*306 + 5)/10 + ( day - 1 )) - first + 1
}

julianDate(1960, month:  9, day: 28)
julianDate(1900, month:  1, day: 1)
julianDate(1900, month: 12, day: 31)
julianDate(1901, month: 1, day: 1)
julianDate(1901, month: 1, day: 1) - julianDate(1900, month: 1, day: 1)
julianDate(2001, month: 1, day: 1) - julianDate(2000, month: 1, day: 1)
isLeap(1960)
isLeap(1900)
isLeap(2000)
