// Week 4 Code Challenges

import UIKit

// CLASS 1: Given an array of ints of odd length, return a new array length 3 containing the elements from the middle of the array. The array length will be at least 3.

let array = [1, 2, 3, 4, 5, 6, 7]

func odd(array: [Int]) -> [Int] {
    return Array(array[(array.count / 2 - 1)...(array.count / 2 + 1)])
}

odd(array)

// CLASS 2: Write a function that takes in an array of numbers, and returns the lowest and highest numbers as a tuple.

let test = [1, 2, 5, 10, 20, 3]

func tupleHighLow(input: [Int]) -> (min: Int?, max: Int?) {
    let elements = input
    let output = (elements.minElement(), elements.maxElement())
    print(output)
    return output
}

tupleHighLow(test)



