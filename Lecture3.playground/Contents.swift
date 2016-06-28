//: Playground - noun: a place where people can play

import UIKit
import Foundation

let immutableString = "Hello, playground"
var str = "Hello, playground"

//let makes the thing immutable, not variable
//str can be changed and can be changed to something else but if u try to change immutableString it will give u compiler error
// you want things that u write to be immutable in general unless u specifically need to change it
//red dot with white in it - compiler can help fix this error

var myInt = 42
let myConstant = 50
// these are ints

let implicitDouble = 70.0
let explciitDOuble: Double = 70
//first touch on the swift type system. Type inference 


let label = "the width is"
let width = 94
let widthLabel = label + String(width)
let apples = 3
let oranges = 5
let appleSummary = "I have \(apples) apples."
let orangeSummary = "I have \(oranges) oranges"
//it wil call the description method inside the parenthesis 

// what do you mean by doing things at compile time versus run time?

//array of strings (implicitly determined)
var shoppingList = ["catfish", "water", "tulips", "blue paint"]

//array of ANY (implicitly determined)
var shoppingList2 = ["catfish", "water", "tulips", "blue paint", 47]
var copyList = shoppingList2
shoppingList2.append(51)

copyList

//should copyList include 51 or no? No, not in swift. It's not a reference to one object shoppingList2. when you append it creates a new shoppingList2. passbyreference object vs passbyvalueobject


//There are reference type arrays
var newList: NSMutableArray = ["catfish", "water", "tulips"]
var copyList2 = newList
newList.addObject(47)
copyList2


//Explicit typing:

//array of ANY (implicitly determined)
var shoppingList3: Array<String> = ["catfish", "water", "tulips", "blue paint"]
//cannot append number now

//Array - generic type. array is a generic list of anything. Array<String> is a very specific thing. This is how you fo type safety in swift "Parameter of a generic type" 

//Dictionary, type is Dictionary<String, String>
var occupation = [
    "malcom" : "captain",
    "kalyee" : "mechanic"
]
// can also declare explcitly: occuptaion:Dictionary<String, String> = [...]

occupation["Jayne"] = "Public Relations"


var r = 50...100 //... says 100 inclusive
var g = r.generate()
g.next()
g.next()

var g1 = [11,21,31,41,51].generate()

var tuple1 = (1,2)
tuple1.0
tuple1.1

var tuple2 = (first:"van", last: "Simmons")
tuple2.0
tuple2.last

for (k,v) in occupation {
    print ("\(k), \(v)")
}

//Top level function
func doubler (x:Int) -> Int {
    return x*2
}
doubler(4)

func progression(v: Int, f:Int -> Int ) -> Int {
    return f(v)
}

progression(4, f: doubler)

//function is also type. (Double) -> Double is a function that takes in a double and returns a double
// any place u can pass an argument u can pass a function. 
// didn't understand what he said about naming the second variable and how that will change in the next version of swift

//Strongly typed and weakly typed 


//Homework asks to make an array of an array of booleans 

var tf = false
tf = true

var arrArr = []
var arrArr2 = [[]]
var arrArr3 = [[true]]
var arrArr4: Array<Array<Bool>> = [[true]]
//why does it have to say true inside?

var arrArr5: Array<Dictionary<Int,Bool>> = [[1:true]]

//anonymous function
var closure = {(x: Int) -> Int in
return x*2
}

closure(6)
progression(6, f: closure) // equivalent to:
progression(6,f: {(x:Int) -> Int in
    return x*2
})

//Also:
progression(6) {(x:Int) -> Int in
    return x*2
}

//why would u make this a variable instead of a function? 
// because u may not want to make a global name for ur function, u want something that has local scope. 

//listen to map explanation
var occupationNames = occupation.map{(k:String, v:String) -> String in
    return k
}
occupationNames

var occupationNames2 = occupation.map{return $0.0}
occupationNames2

var occupationNames3 = occupation.map{$0.0}
occupationNames3

var occupationNames4 = occupation.map{$0.0}.map {$0; "blah"}
occupationNames4

//OPTIONALS 

//? means it can either be a string or it can be nothing
var n:String? = nil


var optionalN: Int? = nil
var optionalN2: Int? = 14


if let n = optionalN{
    let doubleN = doubler(n)
}

if let n = optionalN2{
    let doubleN = doubler(n)
}

var implicitOptionalN: Int! // ! means this is an optional type but compiler dont worry this will always have a value when u call it at runtime so u can let the if let stuff happen on its own 

// thus, diff between bang and question is ? makes u handle all this if let , because compiler makes u go and check and unwrap things expicitly and if u do ! it handles that for u 

//So where Int? is not the same as Int
//Int! is the same type as int
//Passing in Int! instead of Int will compile 
//It's a promise -- that I understand the optionality and at runtime this will not be nil 




