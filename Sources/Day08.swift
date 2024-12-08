//
//  Day08.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 08.12.2024.
//

import Algorithms

struct Day08: AdventDay {
  var data: String

  struct Antenna {
    let x: Int
    let y: Int
    let frequency: Frequency
  }

  typealias Frequency = Character
  typealias MapSize = (width: Int, height: Int)

  func parseInput() -> (antennas: [Frequency: [Antenna]], mapSize: MapSize) {
    let lines = data.split(separator: "\n")

    var antennas: [Frequency: [Antenna]] = [:]

    let mapSize = (width: lines[0].count, height: lines.count)

    for (index, line) in lines.enumerated() {
      for (charIndex, char) in line.enumerated() {
        if char != "." {
          antennas[char, default: []].append(Antenna(x: index, y: charIndex, frequency: char))
        }
      }
    }

    return (antennas, mapSize)
  }

  struct AntiNode: Hashable, Equatable {
    let x: Int
    let y: Int

    func isInsideMap(mapSize: MapSize) -> Bool {
      x >= 0 && x < mapSize.width && y >= 0 && y < mapSize.height
    }
  }

  func getAntinodes(antennas: [Antenna], mapSize: MapSize) -> Set<AntiNode> {
    guard antennas.count >= 2 else { return [] }
    var antiNodes: Set<AntiNode> = []

    let combinations = antennas.combinations(ofCount: 2)

    for pair in combinations {
      let xOffset = pair[0].x - pair[1].x
      let yOffset = pair[0].y - pair[1].y

      let antinode1 = AntiNode(x: pair[0].x + xOffset, y: pair[0].y + yOffset)
      let antinode2 = AntiNode(x: pair[1].x + -xOffset, y: pair[1].y + -yOffset)

      if antinode1.isInsideMap(mapSize: mapSize) {
        antiNodes.insert(antinode1)
      }
      if antinode2.isInsideMap(mapSize: mapSize) {
        antiNodes.insert(antinode2)
      }
    }

    return antiNodes
  }

  func getHarmonicAntinodes(antennas: [Antenna], mapSize: MapSize) -> Set<AntiNode> {
    guard antennas.count >= 2 else { return [] }
    var antiNodes: Set<AntiNode> = []

    let combinations = antennas.combinations(ofCount: 2)

    for pair in combinations {
      let xOffset = pair[0].x - pair[1].x
      let yOffset = pair[0].y - pair[1].y

      var currentAntinode = AntiNode(x: pair[0].x, y: pair[0].y)

      while currentAntinode.isInsideMap(mapSize: mapSize) {
        antiNodes.insert(currentAntinode)
        currentAntinode = AntiNode(x: currentAntinode.x + xOffset, y: currentAntinode.y + yOffset)
      }

      var currentAntinode2 = AntiNode(x: pair[1].x, y: pair[1].y)

      while currentAntinode2.isInsideMap(mapSize: mapSize) {
        antiNodes.insert(currentAntinode2)
        currentAntinode2 = AntiNode(x: currentAntinode2.x + -xOffset, y: currentAntinode2.y + -yOffset)
      }
    }

    return antiNodes
  }

  func part1() -> Int {
    let (antennas, mapSize) = parseInput()
    var allAntinodes: Set<AntiNode> = []
    for frequency in antennas.keys {
      let antiNodes = getAntinodes(antennas: antennas[frequency]!, mapSize: mapSize)
      allAntinodes.formUnion(antiNodes)
    }

    return allAntinodes.count
  }

  func part2() -> Int {
    let (antennas, mapSize) = parseInput()
    var allAntinodes: Set<AntiNode> = []
    for frequency in antennas.keys {
      let antiNodes = getHarmonicAntinodes(antennas: antennas[frequency]!, mapSize: mapSize)
      allAntinodes.formUnion(antiNodes)
    }

    return allAntinodes.count
  }
}
