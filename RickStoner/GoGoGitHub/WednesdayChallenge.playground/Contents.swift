//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

func twoWithinTen(number: Int) -> Bool {
    if number % 10 <= 2 || number % 10 >= 8 {
        return true
    } else {
        return false
    }
}

let test1 = 1
let test2 = 8
let test3 = 7

twoWithinTen(test1)
twoWithinTen(test2)
twoWithinTen(test3)