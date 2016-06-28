//: Playground - noun: a place where people can play

import UIKit

//Given an array of ints of odd length, return a new array length 3 containing the elements from the middle of the array. The array length will be at least 3.
func middleOfArray(array : [Int]) -> [Int] {
    let midInx = array.count/2
    return Array(array[(midInx-1)...(midInx+1)])
}

//Tests
let arr1 = [0,1,2,]
middleOfArray(arr1) 