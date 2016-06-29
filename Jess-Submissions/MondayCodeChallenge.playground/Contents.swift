//: Playground - noun: a place where people can play

import UIKit

func midArray(array: [Int]) -> [Int]
{
    var emptyArray = [Int](count: 3, repeatedValue: 0)
    let midIndex = array.count / 2
    
    emptyArray[0] = (array[midIndex - 1])
    emptyArray[1] = (array[midIndex])
    emptyArray[2] = (array[midIndex + 1])
    
    return emptyArray
}

let myArray = [0, 1, 2, 3, 4, 5, 6]

midArray(myArray)


