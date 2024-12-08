//
//  Day08.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 08.12.2024.
//

import Testing

@testable import AdventOfCode

struct Day08Tests {
  let testData = """
  ............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............
  """

  @Test func testPart1() async throws {
    let challenge = Day08(data: testData)
    #expect(Int(challenge.part1()) == 14)
  }

  @Test()
  func testPart2() async throws {
    let challenge = Day08(data: testData)
    #expect(Int(challenge.part2()) == 34)
  }
}
