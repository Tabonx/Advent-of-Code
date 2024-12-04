//
//  Day04.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 04.12.2024.
//

import Algorithms

struct Day04: AdventDay {
  var data: String

  func parseInput() -> [[Character]] {
    data.split(separator: .newlineSequence).map { Array($0) }
  }

  struct Position: Hashable {
    let row: Int
    let column: Int
  }

  func countXMASPatterns(in grid: [[Character]]) -> Int {
    let pattern: [Character] = Array("XMAS")

    let directions: [(dRow: Int, dCol: Int)] = [
      (0, 1), // right
      (1, 0), // down
      (1, 1), // diagonal down-right
      (-1, 1), // diagonal up-right
      (0, -1), // left
      (-1, 0), // up
      (-1, -1), // diagonal up-left
      (1, -1), // diagonal down-left
    ]

    var count = 0

    func isValid(_ pos: Position) -> Bool {
      return pos.row >= 0 && pos.row < grid.count && pos.column >= 0 && pos.column < grid[0].count
    }

    func checkPattern(start: Position, direction: (dRow: Int, dCol: Int)) -> Bool {
      var currentPos = start

      for char in pattern {
        guard isValid(currentPos), grid[currentPos.row][currentPos.column] == char else {
          return false
        }
        currentPos = Position(
          row: currentPos.row + direction.dRow,
          column: currentPos.column + direction.dCol
        )
      }
      return true
    }

    for row in 0 ..< grid.count {
      for col in 0 ..< grid[0].count {
        let start = Position(row: row, column: col)
        if grid[row][col] == "X" {
          for direction in directions {
            if checkPattern(start: start, direction: direction) {
              count += 1
            }
          }
        }
      }
    }

    return count
  }

  func part1() -> Int {
    return countXMASPatterns(in: parseInput())
  }

  // MARK: - part 2

  func countMASPatterns(in grid: [[Character]]) -> Int {
    let msPattern: [Character] = Array("MS")
    let smPattern: [Character] = Array("SM")

    let diagonalDirection: [[(dRow: Int, dCol: Int)]] = [
      [
        (1, -1), // diagonal down-left
        (-1, 1), // diagonal up-right
      ], [
        (-1, -1), // diagonal up-left
        (1, 1), // diagonal down-right
      ],
    ]

    var count = 0

    func isValid(_ pos: Position) -> Bool {
      return pos.row >= 0 && pos.row < grid.count && pos.column >= 0 && pos.column < grid[0].count
    }

    func checkPattern(start: Position) -> Bool {
      var valid = 0

      for diagonal in diagonalDirection {
        var currentPattern = [Character]()

        for direction in diagonal {
          var currentPos = start
          currentPos = Position(
            row: currentPos.row + direction.dRow,
            column: currentPos.column + direction.dCol
          )

          guard isValid(currentPos) else {
            return false
          }

          let char = grid[currentPos.row][currentPos.column]

          currentPattern.append(char)
        }

        guard currentPattern == msPattern || currentPattern == smPattern else {
          return false
        }
        valid += 1
      }

      return valid == diagonalDirection.count
    }

    for row in 0 ..< grid.count {
      for col in 0 ..< grid[0].count {
        let start = Position(row: row, column: col)
        if grid[row][col] == "A" {
          if checkPattern(start: start) {
            count += 1
          }
        }
      }
    }

    return count
  }

  func part2() -> Int {
    return countMASPatterns(in: parseInput())
  }
}
