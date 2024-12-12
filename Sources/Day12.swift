//
//  Day12.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 12.12.2024.
//

import Algorithms
import Foundation

struct Day12: AdventDay {
  var data: String

  func parseInput() -> [[Character]] {
    data.split(separator: .newlineSequence).map { Array($0) }
  }

  struct Point: Hashable {
    let x: Int
    let y: Int
  }

  func part1() -> Int {
    let input = parseInput()
    return totalFencingCostWithSides(input).normalCost
  }

  func totalFencingCostWithSides(
    _ garden: [[Character]]
  ) -> (normalCost: Int, reducedCost: Int) {
    func isValid(_ point: Point) -> Bool {
      return point.x >= 0 && point.x < garden.count && point.y >= 0 && point.y < garden[0].count
    }

    let rows = garden.count
    let cols = garden[0].count

    let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]

    var visited = Set<Point>()

    func calculatePlot(point: Point, plantType: Character) -> (area: Int, perimeter: Int, corners: Int) {
      var cellsToVisit = [point]
      var regionArea = 0
      var regionPerimeter = 0
      var corners = 0

      while !cellsToVisit.isEmpty {
        let currentPoint = cellsToVisit.removeLast()

        if visited.contains(currentPoint) { continue }

        visited.insert(currentPoint)
        regionArea += 1

        let currentPlant = garden[currentPoint.x][currentPoint.y]

        let x = currentPoint.x
        let y = currentPoint.y

        // 1 - Different Plant
        // 0 - Same Plant

        let down = garden[safe: x + 1]?[safe: y] == currentPlant ? 0 : 1
        let right = garden[safe: x]?[safe: y + 1] == currentPlant ? 0 : 1
        let up = garden[safe: x - 1]?[safe: y] == currentPlant ? 0 : 1
        let left = garden[safe: x]?[safe: y - 1] == currentPlant ? 0 : 1
        let upRight = garden[safe: x - 1]?[safe: y + 1] == currentPlant ? 0 : 1
        let upLeft = garden[safe: x - 1]?[safe: y - 1] == currentPlant ? 0 : 1
        let downRight = garden[safe: x + 1]?[safe: y + 1] == currentPlant ? 0 : 1
        let downLeft = garden[safe: x + 1]?[safe: y - 1] == currentPlant ? 0 : 1

        // Left and up are different OR left and up are the same, but the upper-left diagonal is different
        if left + up == 2 || (left + up == 0 && upLeft == 1) { corners += 1 }
        // Left and down are different OR left and down are the same, but the lower-left diagonal is different
        if left + down == 2 || (left + down == 0 && downLeft == 1) { corners += 1 }
        // Right and up are different OR right and up are the same, but the upper-right diagonal is different.
        if right + up == 2 || (right + up == 0 && upRight == 1) { corners += 1 }
        // Right and down are different OR right and down are the same, but the lower-right diagonal is different.
        if right + down == 2 || (right + down == 0 && downRight == 1) { corners += 1 }

        for (dx, dy) in directions {
          let neighbor = Point(x: currentPoint.x + dx, y: currentPoint.y + dy)
          if isValid(neighbor) {
            if garden[neighbor.x][neighbor.y] == plantType {
              if !visited.contains(neighbor) {
                cellsToVisit.append(neighbor)
              }
            } else {
              regionPerimeter += 1
            }
          } else {
            regionPerimeter += 1
          }
        }
      }

      return (regionArea, regionPerimeter, corners)
    }
    var totalCost = 0
    var reducedCost = 0

    for x in 0 ..< rows {
      for y in 0 ..< cols {
        let point = Point(x: x, y: y)
        if !visited.contains(point) {
          let (area, perimeter, corners) = calculatePlot(point: point, plantType: garden[x][y])
          totalCost += area * perimeter
          reducedCost += area * corners
//          print("plant", garden[x][y], "area", area, "perimeter", perimeter, "corners", corners)
        }
      }
    }

    return (totalCost, reducedCost)
  }

  func part2() -> Int {
    let input = parseInput()

    return totalFencingCostWithSides(input).reducedCost
  }
}
