//: Playground - noun: a place where people can play

import UIKit



func friendOfTen(num: Int) -> Bool
{
    let math = num % 10
    if ((10 - (10 - math)) <= 2 || (10 - math) <= 2)
    
    { return true }
    else { return false }
}

let myNum = 48
let thisNum = 10
let yourNum = 12357
let oneMore = 14590

friendOfTen(myNum)
friendOfTen(thisNum)
friendOfTen(yourNum)
friendOfTen(oneMore)

