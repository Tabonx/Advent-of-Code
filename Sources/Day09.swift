//
//  Day09.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 09.12.2024.
//

import Algorithms

struct Day09: AdventDay {
  var data: String

  enum FormatType: Equatable, CustomStringConvertible {
    case filePart(id: Int, blockSize: Int)
    case empty

    var description: String {
      switch self {
      case .empty:
        return "."
      case let .filePart(id, _):
        return String(id)
      }
    }
  }

  func parseInput() -> [FormatType] {
    var result = [FormatType]()

    var isEmptySpace = false

    var currentID = 0

    for char in data {
      guard let number = char.wholeNumberValue else { continue }

      if isEmptySpace {
        result.append(contentsOf: Array(repeating: .empty, count: number))
      }

      else {
        result.append(contentsOf: Array(repeating: .filePart(id: currentID, blockSize: number), count: number))
        currentID += 1
      }

      isEmptySpace.toggle()
    }

    return result
  }

  func moveFileBlocks(_ diskMap: [FormatType]) -> [FormatType] {
    var diskMap = diskMap

    var tail = diskMap.count - 1

    diskLoop: for head in 0 ..< diskMap.count {
      if diskMap[head] == .empty {
        while diskMap[tail] == .empty {
          if tail <= head { break diskLoop }
          tail -= 1
        }

        diskMap.swapAt(head, tail)
      }
    }

    return diskMap
  }

  func moveWholeBlockSSs(_ diskMap: [FormatType]) -> [FormatType] {
    var diskMap = diskMap

    var lastFileId: Int! = nil
    if case let .filePart(id, _) = diskMap.last(where: { if case .filePart = $0 { return true } else { return false } }) {
      lastFileId = id
    }

    var tail = diskMap.count - 1
    var currentEmptySpaceCount = 0
    var head = 0

    while lastFileId >= 0 {
      var movedBlock = false

      while head < diskMap.count {
        if diskMap[head] == .empty {
          currentEmptySpaceCount += 1
          head += 1
          continue
        }

        if currentEmptySpaceCount != 0 {
          head -= currentEmptySpaceCount
          tail = diskMap.count - 1

          // Try to find a matching block from the end
          while head < tail {
            if case let .filePart(id, blockSize) = diskMap[tail] {
              if lastFileId == id {
                if blockSize <= currentEmptySpaceCount {
                  // Move the block
                  for _ in 0 ..< blockSize {
                    diskMap.swapAt(head, tail)
                    head += 1
                    tail -= 1
                  }
                  movedBlock = true
//                                  print(diskMap.prettyPrinted)
                  break
                }
              }
              tail -= 1
            } else {
              tail -= 1
            }
          }

          if !movedBlock {
            // If we couldn't move any block, skip this empty space
            head += currentEmptySpaceCount
          }
          currentEmptySpaceCount = 0
        }

        head += 1
      }

      // Only move to next file ID if we couldn't move any more blocks of current ID
      if !movedBlock {
        lastFileId -= 1
      }

      // Reset for next iteration
      head = 0
      currentEmptySpaceCount = 0
      tail = diskMap.count - 1
    }

    return diskMap
  }

  func moveWholeBlocks(_ diskMap: [FormatType]) -> [FormatType] {
    var diskMap = diskMap

    var currentFileID: Int! = nil
    if case let .filePart(id, _) = diskMap.last(where: { if case .filePart = $0 { return true } else { return false } }) {
      currentFileID = id
    }

    var tail = diskMap.count - 1

    var currentEmptySpaceCount = 0

    var head = 0

    while currentFileID > 0 {
      if diskMap[head] == .empty {
        currentEmptySpaceCount += 1
        head += 1
        continue
      }

      if currentEmptySpaceCount != 0 {
        head -= currentEmptySpaceCount

        while true {
          guard head < tail else {
            currentFileID -= 1
            head = 0
            currentEmptySpaceCount = 0
            tail = diskMap.count - 1
            break
          }
          if case let .filePart(id, blockSize) = diskMap[tail] {
            guard currentFileID == id else {
              tail -= 1
              continue
            }
            currentFileID -= 1

            if blockSize <= currentEmptySpaceCount {
              for _ in 0 ..< blockSize {
                diskMap.swapAt(head, tail)
                head += 1
                tail -= 1
              }

              break

            } else {
              tail -= blockSize
            }

          } else {
            tail -= 1
          }
        }
        currentEmptySpaceCount = 0
      }
      head += 1
    }

    return diskMap
  }

  func calculateChecksum(_ diskMap: [FormatType]) -> Int {
    var checksum = 0

    for index in 0 ..< diskMap.count {
      if case let .filePart(id, _) = diskMap[index] {
        checksum += (index * id)
      }
    }

    return checksum
  }

  func part1() -> Int {
    let diskMap = parseInput()
    let newDiskMap = moveFileBlocks(diskMap)

    return calculateChecksum(newDiskMap)
  }

  func part2() -> Int {
    let diskMap = parseInput()

    let newDiskMap = moveWholeBlocks(diskMap)
//    print(newDiskMap.prettyPrinted)

    return calculateChecksum(newDiskMap)
  }
}

extension Array where Element == Day09.FormatType {
  var prettyPrinted: String {
    map { $0.description }.joined()
  }
}
