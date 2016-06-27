//: Playground - noun: a place where people can play

import UIKit
//Without Assumptions in Original Question
func findMiddleThree<T> (input: [T]) -> [T]? {
    if input.count % 2 == 0 {
        print("Input is invalid, must be an odd sized array")
    } else {
        if input.count >= 3 {
            let outputArray = Array(input[(input.count / 2).predecessor()...(input.count / 2).successor()])
            return outputArray
        } else {
            print("Input is invalid, array must contain at least 3 items")
        }
    }
    return nil
}

//With Assumptions in Original Question
func findMiddleThreeVTwo<T> (input: [T]) -> [T] {
      return Array(input[(input.count / 2).predecessor()...(input.count / 2).successor()])
  
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

findMiddleThreeVTwo(test)