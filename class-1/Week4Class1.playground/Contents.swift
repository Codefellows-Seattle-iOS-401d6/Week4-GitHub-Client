//: Playground - noun: a place where people can play

import UIKit

let array: [Int] = [1,2,3]
let array2: [Int] = [1,3,5,7,9]


//Given an array of ints of odd length, return a new array length 3 containing the elements from the middle of the array. The array length will be at least 3.

func middleOut(array: [Int]) -> [Int]
{
    let middle = array.count / 2
    
    return Array(array[middle - 1 ... middle + 1])
}

print("\(array) => \(middleOut(array))")
print("\(array2) => \(middleOut(array2))")
