//
//  Day11.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 11.12.2024.
//

import Algorithms
import Foundation

struct Day11: AdventDay {
  var data: String

  // Original approach
  func parseInput() -> [Stone] {
    data.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ").compactMap { Int($0) }.map { Stone(markValue: $0) }
  }

  struct Stone {
    let markValue: Int

    func tick() -> [Stone] {
      if markValue == 0 {
        return [Stone(markValue: 1)]
      }

      let stringMark = String(markValue)

      if stringMark.count % 2 == 0 {
        let left = stringMark.prefix(stringMark.count / 2)
        let right = stringMark.suffix(stringMark.count / 2)

        return [
          Stone(markValue: Int(left)!),
          Stone(markValue: Int(right)!),
        ]
      }

      return [Stone(markValue: markValue * 2024)]
    }
  }

  func part1() -> Int {
    var stones = parseInput()

    var newStones = [Stone]()

    for index in 0 ..< 25 {
      for stone in stones {
        newStones.append(contentsOf: stone.tick())
      }

      stones = newStones
      if index != 24 {
        newStones = []
      }
    }

    return newStones.count
  }

  // When I realized it would not finish till the end of the year...

  func parseInputToDictionary() -> [Int: Int] {
    let numbers = data.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ").compactMap { Int($0) }

    return Dictionary(grouping: numbers, by: { $0 }).mapValues(\.count)
  }

  func part2() -> Int {
    runner(input: parseInputToDictionary(), blinks: 75)
  }

  func runner(input: [Int: Int], blinks: Int) -> Int {
    var dict = input
    for _ in 0 ..< blinks {
      dict = step(dict)
    }
    return dict.values.reduce(0, +)
  }

  func step(_ input: [Int: Int]) -> [Int: Int] {
    var result = [Int: Int]()

    if let zeroCount = input[0] {
      result[1] = zeroCount
    }

    for (number, count) in input where number != 0 {
      // When I asked Claude how to get the number of digits without converting to String... ¯\_(ツ)_/¯
      let digits = Int(log10(Double(number))) + 1

      if digits % 2 == 0 {
        // When I asked Claude how to split Int into two... ¯\_(ツ)_/¯
        let divisor = Int(pow(10.0, Double(digits / 2)))
        let left = number / divisor
        let right = number % divisor

        result[left, default: 0] += count
        result[right, default: 0] += count
      } else {
        result[number * 2024, default: 0] += count
      }
    }

    return result
  }
}

extension Array where Element == Day11.Stone {
  var toSpaceSeparatedString: String {
    map { String($0.markValue) }.joined(separator: " ")
  }
}
