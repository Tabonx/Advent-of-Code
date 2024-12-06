//
//  Day06.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 06.12.2024.
//

import Algorithms

struct Day06: AdventDay {
  var data: String

  enum PlayerDirection: Equatable, Hashable {
    case up
    case down
    case left
    case right

    func rotateRight() -> PlayerDirection {
      switch self {
      case .up:
        return .right
      case .right:
        return .down
      case .down:
        return .left
      case .left:
        return .up
      }
    }

    init(_ character: Character) {
      switch character {
      case "^":
        self = .up

      case "<":
        self = .left

      case ">":
        self = .right

      case "v":
        self = .down

      default:
        fatalError()
      }
    }

    var direction: (rowOffset: Int, columnOffset: Int) {
      switch self {
      case .up:
        (-1, 0)
      case .down:
        (1, 0)
      case .left:
        (0, -1)
      case .right:
        (0, 1)
      }
    }
  }

  enum GridElement: Equatable {
    case player(direction: PlayerDirection)
    case obstacle
    case empty
    case playerVisited

    init(_ character: Character) {
      switch character {
      case "#":
        self = .obstacle

      case ".":
        self = .empty

      case "X":
        self = .playerVisited

      case "^", "<", ">", "v":
        self = .player(direction: .init(character))

      default:
        fatalError()
      }
    }
  }

  func parseInput() -> [[GridElement]] {
    let lines = data.split(separator: "\n").map { $0.map { GridElement($0) }}

    return lines
  }

  func getPlayer(grid: [[GridElement]]) -> (direction: PlayerDirection, rowIndex: Int, columnIndex: Int) {
    for (rowIndex, row) in grid.enumerated() {
      for (columnIndex, column) in row.enumerated() {
        if case let .player(direction) = column {
          return (direction, rowIndex, columnIndex)
        }
      }
    }

    fatalError()
  }

  func play() -> Int {
    var grid = parseInput()

    var (direction, playerRowIndex, playerColumnIndex) = getPlayer(grid: grid)

    while true {
      guard playerRowIndex >= 0, playerRowIndex < grid.count,
            playerColumnIndex >= 0, playerColumnIndex < grid[0].count else {
        break
      }

      let originalRow = playerRowIndex
      let originalColumn = playerColumnIndex

      let offset = direction.direction

      let newRowIndex = playerRowIndex + offset.rowOffset
      let newColumnIndex = playerColumnIndex + offset.columnOffset

      guard newRowIndex >= 0, newRowIndex < grid.count,
            newColumnIndex >= 0, newColumnIndex < grid[0].count else {
        break
      }

      if grid[newRowIndex][newColumnIndex] == .obstacle {
        direction = direction.rotateRight()

        continue
      }

      grid[originalRow][originalColumn] = .playerVisited
      playerRowIndex = newRowIndex
      playerColumnIndex = newColumnIndex
    }

    let count = grid.flatMap { $0 }.count { $0 == .playerVisited }

    return count + 1
  }

  func part1() -> Int {
    play()
  }

  func getNumberOfLoops() -> Int {
    let grid = parseInput()
    var resultLoops = 0

    for rowIndex in grid.indices {
      for columnIndex in grid[rowIndex].indices {
        var mutatedGrid = grid
        if case .player = mutatedGrid[rowIndex][columnIndex] {
          continue
        }
        if case .obstacle = mutatedGrid[rowIndex][columnIndex] {
          continue
        }

        mutatedGrid[rowIndex][columnIndex] = .obstacle
        if checkForLoop(grid: mutatedGrid) {
          resultLoops += 1
        }
      }
    }
    return resultLoops
  }

  func checkForLoop(grid: [[GridElement]]) -> Bool {
    let (originalDirection, originalPlayerRowIndex, originalPlayerColumnIndex) = getPlayer(grid: grid)

    var direction = originalDirection
    var playerRowIndex = originalPlayerRowIndex
    var playerColumnIndex = originalPlayerColumnIndex

    var pathStates = Set<String>()

    while true {
      let currentState = "\(playerRowIndex),\(playerColumnIndex),\(direction)"
      if pathStates.contains(currentState) {
        return true
      }
      pathStates.insert(currentState)

      // Calculate next position
      let offset = direction.direction
      let newRowIndex = playerRowIndex + offset.rowOffset
      let newColumnIndex = playerColumnIndex + offset.columnOffset

      if newRowIndex < 0 || newRowIndex >= grid.count ||
        newColumnIndex < 0 || newColumnIndex >= grid[0].count {
        return false
      }

      if grid[newRowIndex][newColumnIndex] == .obstacle {
        direction = direction.rotateRight()
      } else {
        playerRowIndex = newRowIndex
        playerColumnIndex = newColumnIndex
      }

      if pathStates.count > grid.count * grid[0].count * 4 {
        return true
      }
    }
  }

  func part2() -> Int {
    return getNumberOfLoops()
  }
}
