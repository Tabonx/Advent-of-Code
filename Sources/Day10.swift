//
//  Day10.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 10.12.2024.
//

import Algorithms

struct Day10: AdventDay {
  var data: String

  func parseInput() -> [[Int]] {
    data.split(separator: "\n").map { $0.compactMap { $0.wholeNumberValue }}
  }

  func getTrails(map: [[Int]], unique: Bool) -> Int {
    let rows = map.count
    let cols = map[0].count
    var startPoints: [Point] = []
    var pathCount = 0

    for i in 0 ..< rows {
      for j in 0 ..< cols {
        if map[i][j] == 0 {
          startPoints.append(Point(x: i, y: j))
        }
      }
    }

    var visited: Set<Point> = []

    let directions = [(-1, 0), (0, 1), (1, 0), (0, -1)]

    func isValid(_ point: Point) -> Bool {
      return point.x >= 0 && point.x < rows && point.y >= 0 && point.y < cols
    }

    for start in startPoints {
      trace(start, currentValue: 0, unique: unique)
      visited = []
    }

    func trace(_ current: Point, currentValue: Int, unique: Bool) {
      if map[current.x][current.y] == 9 {
        if unique {
          if !visited.contains(current) {
            pathCount += 1
          }
          visited.insert(current)
        } else {
          pathCount += 1
        }
        return
      }

      for (dx, dy) in directions {
        let next = Point(x: current.x + dx, y: current.y + dy)
        if isValid(next), map[next.x][next.y] == (currentValue + 1) {
          trace(next, currentValue: currentValue + 1, unique: unique)
        }
      }
    }

    return pathCount
  }

  func part1() -> Int {
    let map = parseInput()
    return getTrails(map: map, unique: true)
  }

  func part2() -> Int {
    let map = parseInput()
    return getTrails(map: map, unique: false)
  }

  struct Point: Hashable {
    let x: Int
    let y: Int
  }
}
