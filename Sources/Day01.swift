//
//  Day01.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 01.12.2024.
//

import Algorithms

struct Day01: AdventDay {
  var data: String

  var entities: [[Int]] {
    data.split(separator: "\n\n").map {
      $0.split(separator: "   ").compactMap { Int($0) }
    }
  }

  func parseInput() -> (left: [Int], right: [Int]) {
    let rows = data.split(separator: "\n")

    var leftColumn = [Int]()
    var rightColumn = [Int]()

    for row in rows {
      let s = row.split(separator: "   ").compactMap { Int($0) }
      leftColumn.append(s[0])
      rightColumn.append(s[1])
    }

    return (leftColumn, rightColumn.sorted())
  }

  func part1() -> Int {
    let (leftRaw, rightRaw) = parseInput()

    let left = leftRaw.sorted()
    let right = rightRaw.sorted()

    return zip(left, right)
      .map { abs($0 - $1) }
      .reduce(0, +)
  }

  func part2() -> Int {
    let (left, right) = parseInput()

    let leftFreq = left.reduce(into: [:]) { $0[$1, default: 0] += 1 }
    let rightFreq = right.reduce(into: [:]) { $0[$1, default: 0] += 1 }

    return leftFreq.reduce(0) { result, pair in
      let (number, leftCount) = pair
      let rightCount = rightFreq[number, default: 0]
      return result + (number * leftCount * rightCount)
    }
  }
}
