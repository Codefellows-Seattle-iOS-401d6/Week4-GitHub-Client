//: Playground - noun: a place where people can play

import UIKit

func proximityDetectorWithinTwo (num: Int) -> Bool {
    if num % 10 <= 2 || num % 10 >= 8{
        return true
    }
    return false
}

proximityDetectorWithinTwo(32)
proximityDetectorWithinTwo(31)
proximityDetectorWithinTwo(33)
proximityDetectorWithinTwo(30)
proximityDetectorWithinTwo(29)
proximityDetectorWithinTwo(28)
proximityDetectorWithinTwo(27)
proximityDetectorWithinTwo(34)
