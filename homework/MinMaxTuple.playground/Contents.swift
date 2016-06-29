//: Playground - noun: a place where people can play

import UIKit

func findMinMax (input: [Int]) -> (min: Int, max: Int) {
    var currentMin = input[0]
    var currentMax = input[0]
    
    for value in input[1..<input.count] {
        if currentMin < value {
            currentMin = value
        } else if currentMax > value {
            currentMax = value
        }
    }
    
    return (currentMin, currentMax)
}


let test = [20, 3, 4, 5, 1, 55, 341, 1]

findMinMax(test)