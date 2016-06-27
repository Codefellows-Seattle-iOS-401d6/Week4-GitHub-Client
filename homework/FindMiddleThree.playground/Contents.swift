//: Playground - noun: a place where people can play

import UIKit

func findMiddleThree<T> (input: [T]) -> [T?]? {
    if input.count % 2 == 0 {
        print("Input is invalid, must be an odd sized array")
    } else {
        if input.count >= 3 {
            let middleIndex = (input.count / 2)
            var outputArray = [T?](count: 3, repeatedValue: nil)
            for index in 0...2 {
                outputArray[index] = input[middleIndex.predecessor() + index]
            }
            return outputArray
        } else {
            print("Input is invalid, array must contain at least 3 items")
        }
    }
    return nil
}

let test = [2, 3, 4, 15, 3, 4, 5]
let test2 = ["hi", "bye", "hello"]
let test3 = [Int]()
let test4 = ["hello"]
let test5 = [2, 3]

findMiddleThree(test)
findMiddleThree(test2)
findMiddleThree(test3)
findMiddleThree(test4)
findMiddleThree(test5)