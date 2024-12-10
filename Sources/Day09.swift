//
//  Day09.swift
//  AdventOfCode
//
//  Created by Pavel Kroupa on 09.12.2024.
//

// https://github.com/gereons/AoC2024/blob/main/Sources/Day09/Day09.swift

extension Collection {
  subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}

struct Day09: AdventDay {
  var data: String

  let map: [Int]

  init(data: String) {
    self.data = data
    map = data.filter { !$0.isWhitespace }.map { Int(String($0))! }
  }

  func part1() -> Int {
    return 0
//    var blocks = [Int]()
//    var fileId = 0
//    for (index, digit) in map.enumerated() {
//      if index.isMultiple(of: 2) {
//        // a file
//        blocks.append(contentsOf: [Int](repeating: fileId, count: digit))
//        fileId += 1
//      } else {
//        // free space
//        blocks.append(contentsOf: [Int](repeating: -1, count: digit))
//      }
//    }
//
//    var firstFree = -1
//    while let firstFreeIndex = firstFreeIndex(after: firstFree, in: blocks) {
//      var last: Int
//      repeat {
//        last = blocks.removeLast()
//      } while last == -1
//
//      blocks[firstFreeIndex] = last
//      firstFree = firstFreeIndex
//    }
//
//    var checksum = 0
//    for (index, id) in blocks.enumerated() {
//      checksum += index * id
//    }
//    return checksum
  }

  enum Block {
    case file(id: Int, size: Int)
    case free(size: Int)

    var isFree: Bool {
      switch self {
      case .file: false
      case .free: true
      }
    }

    func isFree(minSize: Int) -> Bool {
      switch self {
      case .file: false
      case let .free(size): size >= minSize
      }
    }

    func isFile(id: Int) -> Bool {
      switch self {
      case let .file(fileId, _): fileId == id
      case .free: false
      }
    }

    var size: Int {
      switch self {
      case let .file(_, size): size
      case let .free(size): size
      }
    }
  }

  func part2() -> Int {
    var blocks = [Block]()
    var fileSizes = [Int: Int]()
    var fileId = 0
    for (index, digit) in map.enumerated() {
      if index.isMultiple(of: 2) {
        // a file
        blocks.append(.file(id: fileId, size: digit))
        fileSizes[fileId] = digit
        fileId += 1
      } else {
        // free space
        blocks.append(.free(size: digit))
      }
    }

    var newBlocks = blocks
    for moveId in (0 ..< fileId).reversed() {
      let fileSize = fileSizes[moveId]!
      let fileIndex = newBlocks.firstIndex(where: { $0.isFile(id: moveId) })!

      guard let freeIndex = firstFreeIndex(before: fileIndex, minSize: fileSize, in: newBlocks) else { continue }

      let freeBlock = newBlocks[freeIndex]
      let freeSize = freeBlock.size
      newBlocks[fileIndex] = .free(size: fileSize)
      newBlocks[freeIndex] = .file(id: moveId, size: fileSize)
      if fileSize == freeSize {
        mergeFree(&newBlocks, at: fileIndex)
      } else {
        newBlocks.insert(.free(size: freeSize - fileSize), at: freeIndex + 1)
        mergeFree(&newBlocks, at: fileIndex + 1)
      }
    }

    var checksum = 0
    for (index, id) in expandBlocks(newBlocks).enumerated() {
      if id != -1 {
        checksum += index * id
      }
    }
    return checksum
  }

  func expandBlocks(_ blocks: [Block]) -> [Int] {
    var result = [Int]()
    for b in blocks {
      switch b {
      case let .file(id, size):
        let arr = [Int](repeating: id, count: size)
        result.append(contentsOf: arr)

      case let .free(size):
        let arr = [Int](repeating: -1, count: size)
        result.append(contentsOf: arr)
      }
    }
    return result
  }

  private func firstFreeIndex(after first: Int, in array: [Int]) -> Int? {
    var index = first + 1
    while index < array.count {
      if array[index] == -1 { return index }
      index += 1
    }
    return nil
  }

  private func firstFreeIndex(before end: Int, minSize: Int, in array: [Block]) -> Int? {
    for index in 0 ..< end {
      switch array[index] {
      case .file: continue
      case let .free(size): if size >= minSize { return index }
      }
    }
    return nil
  }

  private func mergeFree(_ blocks: inout [Block], at index: Int) {
    let b1 = blocks[safe: index - 1]
    let b2 = blocks[index]
    let b3 = blocks[safe: index + 1]

    switch (b1, b2, b3) {
    case let (.free(s1), .free(s2), .free(s3)):
      blocks[index - 1] = .free(size: s1 + s2 + s3)
      blocks.remove(at: index + 1)
      blocks.remove(at: index)

    case let (.free(s1), .free(s2), _):
      blocks[index - 1] = .free(size: s1 + s2)
      blocks.remove(at: index)

    case let (_, .free(s1), .free(s2)):
      blocks[index] = .free(size: s1 + s2)
      blocks.remove(at: index + 1)

    default:
      break
    }
  }
}
