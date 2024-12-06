//
//  Day06.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 06.12.2024.
//

import Testing

@testable import AdventOfCode

struct Day06Tests {
  let testData = """
  ....#.....
  .........#
  ..........
  ..#.......
  .......#..
  ..........
  .#..^.....
  ........#.
  #.........
  ......#...
  """

  @Test func testPart1() async throws {
    let challenge = Day06(data: testData)
    #expect(Int(challenge.part1()) == 41)
  }

  @Test()
  func testPart2() async throws {
    let challenge = Day06(data: testData)
    #expect(Int(challenge.part2()) == 6)
  }
}
