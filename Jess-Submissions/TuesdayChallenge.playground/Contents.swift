//: Playground - noun: a place where people can play

import UIKit


let array = [23, 67, 2, 90, 46, 1, 7]

func makeTuple(array: [Int]) -> (Int, Int)
{
    let first = array.sort().first
    let last = array.sort().last
    
    let touple = (first!, last!)
    
    return touple
}

makeTuple(array)
