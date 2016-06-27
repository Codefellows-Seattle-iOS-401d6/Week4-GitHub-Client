//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

var test = [1,2,3,4,5,6,7,8,9]

func returnMiddleThree(input: [Int]) -> [Int]
{
    var outputArray: [Int] = []
    
    let median = (input.count - 1)/2
    
    outputArray.append(input[median - 1])
    outputArray.append(input[median])
    outputArray.append(input[median + 1])
    
    return outputArray
}

returnMiddleThree(test)
