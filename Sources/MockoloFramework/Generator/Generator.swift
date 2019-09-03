//
//  Copyright (c) 2018. Uber Technologies
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

import Foundation
import SourceKittenFramework

//
//0.1286710500717163
//0.9639599323272705


//0.06795692443847656
//0.26693594455718994

//0.0660940408706665
//0.5132960081100464

/*
 
str.count 600

 characterset.alphanumeric.contains
 properties
 regex
 
 1.0907258987426758
 0.3417649269104004
 2.062424063682556
 
 charlist.contains
 propeties
 regex
 
 0.22258102893829346
 0.3872849941253662
 2.903406023979187
 
str.count = 600
 0.4073880910873413
 0.42581093311309814
 1.9596259593963623

 0.3079679012298584
 0.4512929916381836
 2.161538004875183
 
 str.count = 135
 0.07489001750946045  // charlist
 0.08946001529693604
 0.5739150047302246
 
 0.2853260040283203  // charaterset.alpha.contains
 0.09337592124938965
 0.6894479990005493
 

 134
 0.10457801818847656
 0.14804601669311523
 0.1610790491104126  // a-z+
 
 
 
 str.count = 116  // all symbols
 0.05228710174560547  // charlist
 0.15911996364593506
 0.02303600311279297
 
 str.count = 700 // all symbols
 0.36650705337524414 // charlist
 0.8915480375289917
 0.046859025955200195

 
str.count = 700 // all symbols
 1.5893020629882812  // set.contains
 0.9620569944381714
 0.0421299934387207
 
 str.cout = 700 // all sym
 0.5060350894927979
 1.4431560039520264
 1.0100250244140625 // regex finds $
 

 0.38960695266723633
 1.081691026687622
 0.6424360275268555
 

// add $
 0.892274022102356
 1.1572569608688354
 0.6411809921264648

 

count = 134  // str = alphanumeric
 0.07882201671600342
 0.09858298301696777
 0.31638097763061523


 530
 0.3381190299987793
 0.4323849678039551
 0.8938719034194946 // just match

 530
 0.3216969966888428
 0.3816370964050293
 2.0754259824752808 // match + get string
 
 
530
 0.7136200666427612
 0.8517179489135742
 0.9490180015563965  // a-z+
 
 

 1295
 0.8062909841537476
 0.9429770708084106
 1.2129219770431519 // a-z+
 
 
 1297
 1298 // w emojis
 0.8639389276504517
 0.9920510053634644
 30.28780996799469  // a-z+  regex+create range

 0.7791190147399902
 1.2883720397949219
 1.4864970445632935 // a-z+ just regex

1297 // no emoji
 0.8536180257797241
 1.0603150129318237
 1.314437985420227  // a-z+ regex+range
 

 1300 // w emoji
 0.7761319875717163
 0.9475929737091064
 1.2827949523925781 // a-z+ regex+range
 
 1295
 0.7759829759597778
 1.0601980686187744
 3.9500529766082764 // a-z*

 
13 w/ emoji
 0.00784599781036377
 0.006520986557006836
 0.05348801612854004 // a-z+
 

 11 no emoji
 0.006477952003479004
 0.003564000129699707
 0.03155100345611572

 
142 w/ emoji
 0.08473503589630127
 0.10192596912384033
 0.7651619911193848
 **/

public func cmp() {

    let str3 = """
!@#$#%$^$*&%(*^&%^$%#$@##^%$&^%*(^)^*&%(^&$%#$@# #@$%$^&*%^^%$@#@%^#&%*(^ @$%^#&$*%(^ _+)(*&^%$#@!~!@#$%^&* #%$^&%*&
!@#$#%$^$*&%(*^&%^$%#$@##^%$&^%*(^)^*&%(^&$%#$@# #@$%$^&*%^^%$@#@%^#&%*(^ @$%^#&$*%(^ _+)(*&^%$#@!~!@#$%^&* #%$^&%*&
!@#$#%$^$*&%(*^&%^$%#$@##^%$&^%*(^)^*&%(^&$%#$@# #@$%$^&*%^^%$@#@%^#&%*(^ @$%^#&$*%(^ _+)(*&^%$#@!~!@#$%^&* #%$^&%*&
!@#$#%$^$*&%(*^&%^$%#$@##^%$&^%*(^)^*&%(^&$%#$@# #@$%$^&*%^^%$@#@%^#&%*(^ @$%^#&$*%(^ _+)(*&^%$#@!~!@#$%^&* #%$^&%*&
!@#$#%$^$*&%(*^&%^$%#$@##^%$&^%*(^)^*&%(^&$%#$@# #@$%$^&*%^^%$@#@%^#&%*(^ @$%^#&$*%(^ _+)(*&^%$#@!~!@#$%^&* #%$^&%*&
!@#$#%$^$*&%(*^&%^$%#$@##^%$&^%*(^)^*&%(^&$%#$@# #@$%$^&*%^^%$@#@%^#&%*(^ @$%^#&$*%(^ _+)(*&^%$#@!~!@#$%^&* #%$^&%*&
"""

    let str4 = "hello 😀 wo😀r ld 😀"

    let str2 = """
"h1234😀  %@#$& 😀 brb 😀^*_+ ello world! foo bar cat dog pig bear tiger . omg: lol(something, array) "
alksjlj lkjl23j4 l2j3 4lkjdfsg j34lk5j
"""

        let str5 = """
    "h1234😀  %@#$& 😀 brb 😀^*_+ ello world! foo bar cat dog pig bear tiger . omg: lol(something, array) "
    alksjlj lkjl23j4 l2j3 4lkjdfsg j34lk5j
    """

    
//    let str = "hello"
let str = """
asdklfj 😀 s klj @#$ 9lkdfjlg $^%09 @# ^&^%&%^* kljasdjf ah1234 %@#$& brb ^*_+ ello world! foo
bar cat dog pig bear tiger . omg: lol(something, array)
123 lkjladf lj 28049b  akdj faj bar cat asdklfj  bear tiger . omgklj @#$ 9lkdfjlg  bear tiger . omg$^%09 @# ^&^%&%^* kljasdjf ah1234 %@#$& brb ^*_+ ello
123 lkjladf lj 28049b  akdj faj bar cat asdklfj  bear tiger . omgklj @#$ 9lkdfjlg  bear tiger . omg$^%09 @# ^&^%&%^* kljasdjf ah1234 %@#$& brb ^*_+ ello
123 lkjladf lj 28049b  akdj faj bar cat asdklfj  bear tiger . omgklj @#$ 9lkdfjlg  bear tiger . omg$^%09 @# ^&^%&%^* kljasdjf ah1234 %@#$& brb ^*_+ ello
123 lkjladf lj 28049b  akdj faj bar cat asdklfj  bear tiger . omgklj @#$ 9lkdfjlg  bear tiger . omg$^%09 @# ^&^%&%^* kljasdjf ah1234 %@#$& brb ^*_+ ello
123 lkjladf lj 28049b  akdj faj bar cat asdklfj  bear tiger . omgklj @#$ 9lkdfjlg  bear tiger . omg$^%09 @# ^&^%&%^* kljasdjf ah1234 %@#$& brb ^*_+ ello
123 lkjladf lj 28049b  akdj faj bar cat asdklfj  bear tiger . omgklj @#$ 9lkdfjlg  bear tiger . omg$^%09 @# ^&^%&%^* kljasdjf ah1234 %@#$& brb ^*_+ ello
lowerklewrl  ekjrlte jrwltj l;k3q lj sfg@#$%^$%*&$ 2qo3i4up295 656*"(:%L^ 5lwrej fldj 5$&:$% ltrsfjd lkvdaks f
bar cat asdklfj  bear tiger . omgklj @#$ 9lkdfjlg  bear tiger . omg$^%09 @# ^&^%&%^* kljasdjf ah1234 %@#$& brb ^*_+ ello
"""
    print(str.count)
    print(str.utf16.count)

//    let q0 = CFAbsoluteTimeGetCurrent()
//    let r = Range(str.range, in: str)
//    let q1 = CFAbsoluteTimeGetCurrent()
//    print(q1-q0)
//    print(r)
//    print(str[r])

    var ret0 = [UnicodeScalar]()
    var ret1 = [UnicodeScalar]()
    
    let total = 10000
    
    let c1 = CFAbsoluteTimeGetCurrent()
    var charlist = CharacterSet.alphanumerics
    charlist.insert(charactersIn: "$")
    for i in 0..<total {
        for u in str.unicodeScalars {
        if charlist.contains(u) {
            ret0.append(u)
        }
    }
    }
    let c2 = CFAbsoluteTimeGetCurrent()
    print(c2-c1)

    
    let a1 = CFAbsoluteTimeGetCurrent()
    for i in 0..<total {
    for u in str.unicodeScalars {
        if u.properties.isAlphabetic || u.properties.numericType == Unicode.NumericType.decimal ||
            u == "$" {
//            || u == " " || u == ":" || u == "," {
            ret1.append(u)
        }
    }
    }
    let a2 = CFAbsoluteTimeGetCurrent()
    print(a2-a1)
//    print(ret1)
    
    
    var ret = [Substring]()
    let range = NSRange(location: 0, length: str.utf16.count)

    let b1 = CFAbsoluteTimeGetCurrent()
    guard let regex = try? NSRegularExpression(pattern: "[a-zA-Z0-9$]+", options: []) else {
         return
    }
    for i in 0..<total {
    let mt = regex.matches(in: str, options: [], range: range)
    for m in mt {
        
        if let rng = Range(m.range) { //Range(m.range, in: str) {
//            let el = str[rng]
//            ret.append(el)
            }
        }
    }
    let b2 = CFAbsoluteTimeGetCurrent()
    print(b2-b1)
    
    print(ret1.count == ret.count)
}


public func prop(_ mockpaths: [String]) -> [String] {
    var ret = [UnicodeScalar]()
    var n = 0
    var stats = [(0.0, 0)]
    var aveDelta = 0.0
    var aveLen = 0
    let chars = UnicodeScalar(unicodeScalarLiteral: ".") // [". <>[]:, ()"]
    for p in mockpaths {
        if let s = try? Structure(path: p), let d = FileManager.default.contents(atPath: p) {
//                for child in s.substructures {
                    for sub in s.substructures {
                        let length = Int64(136) //sub.length
                        let t =  d.toString(offset: sub.offset, length: length)
//                        print(t)

                        let start = CFAbsoluteTimeGetCurrent()
                        
                        for u in t.unicodeScalars {
                            if u.properties.isAlphabetic || u.properties.numericType == Unicode.NumericType.digit
                                || u == " " || u == "." || u == ":" || u == "(" || u == ")"  { //. :()
                                ret.append(u)
                            }
                        }
                        
                        let end = CFAbsoluteTimeGetCurrent()
                        n += 1

                        let delta = end-start
                        let len = Int(length)

                        aveDelta += delta
                        aveLen += len
                        stats.append((delta, len))
                    }
            }
//        }
    }
    
    print("Total: delta", aveDelta, "len", aveLen, "#calls", n, "ret", ret.count)
    aveDelta /= Double(n)
    aveLen /= n
    print("Ave: delta", aveDelta, "len", aveLen)
    return [""]
}

/*
10K calls
 Total: delta 1.461999535560608 len 23698606 #calls 9991 ret 15418380
 Ave: delta 0.0001463316520428994 len 2371

10K calls
 Total: delta 0.12252998352050781 len 1358776 #calls 9991 ret 982961
 Ave: delta 1.2264035984436774e-05 len 136

[added more chars to compare . :()]
 Total: delta 0.1101294755935669 len 1358776 #calls 9991 ret 1260325
 Ave: delta 1.1022868140683304e-05 len 136

190K calls
 Total: delta 3.1786208152770996 len 25873689 #calls 189355 ret 16904509
 Ave: delta 1.6786569223295396e-05 len 136
 **/

public func regex(_ mockpaths: [String]) -> [String] {

    guard let regex = try? NSRegularExpression(pattern: "[a-zA-Z0-9. :()]", options: []) else { return [] }

    var ret = [Substring]()


    var n = 0
    var stats = [(0.0, 0)]
    var aveDelta = 0.0
    var aveLen = 0

    for p in mockpaths {
        if let s = try? Structure(path: p), let d = FileManager.default.contents(atPath: p) {
//                for child in s.substructures {
                    for sub in s.substructures {
                        let length = Int64(136) //sub.length
                        let t =  d.toString(offset: sub.offset, length: length)
//                        print(t)
                        let range = NSRange(location: 0, length: t.count)

                        
                        let start = CFAbsoluteTimeGetCurrent()
                        let matches = regex.matches(in: t, options: [], range: range)
                        let end = CFAbsoluteTimeGetCurrent()
                        for m in matches {
                            if let rng = Range(m.range, in: t) {
                                let el = t[rng]
                                ret.append(el)
                            }
                        }
                        
                        n += 1

                        let delta = end-start
                        let len = Int(length)

                        aveDelta += delta
                        aveLen += len
                        stats.append((delta, len))
                    }
            }
//        }
    }
    
    print("Total: delta", aveDelta, "len", aveLen, "#calls", n, "ret", ret.count)
    aveDelta /= Double(n)
    aveLen /= n
    print("Ave: delta", aveDelta, "len", aveLen)
    return [""]
}


/**
 
 regex.matches

 190K calls
Total: delta 6.5413841009140015 len 25873689 #calls 189355 ret 17073379
Ave: delta 3.454561063037153e-05 len 136

 

10K calls
 Total: delta 0.2640106678009033 len 1358776 #calls 9991 ret 984730
 Ave: delta 2.642484914432022e-05 len 136
 

 [added more chars to compare . :()]
 Total: delta 0.35437965393066406 len 1358776 #calls 9991 ret 1262094
 Ave: delta 3.5469888292529684e-05 len 136
 
 
// 10K calls
// Total: delta 5.039435625076294 len 23698606 #calls 9991 ret 15557567
// Ave: delta 0.0005043975202758777 len 2371

 regex.matches + string[match.range]

 190K calls
 Total: delta 12.496809959411621 len 25873689 #calls 189355 ret 17073379
 Ave: delta 6.599672551245873e-05 len 136
 
 10K calls
 Total: delta 0.6381058692932129 len 1358776 #calls 9991 ret 984730
 Ave: delta 6.386806819069291e-05 len 136

// Total: delta 11.692590236663818 len 23698606 #calls 9991 ret 15557567
// Ave: delta 0.0011703123047406485 len 2371
 
 */

public func use(_ mockpaths: [String], split: Bool) -> [String] {

    var compRet = [""]
    var splitRet = [String]()
    var n = 0
    var stats = [(0.0, 0)]
    var aveDelta = 0.0
    var aveLen = 0

    for p in mockpaths {
        if let s = try? Structure(path: p), let d = FileManager.default.contents(atPath: p) {
//                for child in s.substructures {
                    for sub in s.substructures {
                        let length = Int64(140) //sub.length
                        let t =  d.toString(offset: sub.offset, length: length)
                        var x = [String]()
                        
                        let start = CFAbsoluteTimeGetCurrent()
                        if split {
                            x = t.split(separator: "\n").map {String($0)}
                        } else {
                            x = t.components(separatedBy: "\n")
                        }
                        n += 1
                        let end = CFAbsoluteTimeGetCurrent()
//                        print(x)
                       
                        if split {
                            let y = x // as! [String]
                            splitRet.append(contentsOf: y)
                        } else {
                            let y = x // as! [String]
                            compRet.append(contentsOf: y)
                        }

                        let delta = end-start
                        let len = Int(length)

                        aveDelta += delta
                        aveLen += len
                        stats.append((delta, len))
                    }
            }
//        }
    }
    
    
    print("Total: delta", aveDelta, "len", aveLen, "#calls", n, "split?", split, "#Split", splitRet.count, "#Comp", compRet.count)
    aveDelta /= Double(n)
    aveLen /= n
    print("Ave: delta", aveDelta, "len", aveLen)
    return [""]
}

public func useData(_ mockpaths: [String]) -> [String] {
    var ret = [""]
    var stats = [(0.0, 0)]
    var aveDelta = 0.0
    var aveLen = 0
    for p in mockpaths {
        if let s = try? Structure(path: p), let d = FileManager.default.contents(atPath: p) {
//                for child in s.substructures {
                    for sub in s.substructures {
                        let length = Int64(140) //sub.length
                        let start = CFAbsoluteTimeGetCurrent()
                        let t =  d.toString(offset: sub.offset, length: length)
                        let end = CFAbsoluteTimeGetCurrent()
                        ret.append(t)
                        let delta = end-start
                        let len = Int(length)
                        aveDelta += delta
                        aveLen += len
                        stats.append((delta, len))
                    }
//            }
        }
    }
    
    
    print("Total: delta", aveDelta, "len", aveLen, "#extract calls", ret.count)
    var x = stats.sorted {$0.1 < $1.1}.map {"\($0.0); \($0.1)" }.joined(separator: "\n")
    x.append("#extract calls: \(ret.count)\n")
    x.append("Total delta: \(aveDelta)\n")
    x.append("Total len: \(aveLen)\n")
    aveDelta /= Double(ret.count)
    aveLen /= ret.count
    print("Ave: delta", aveDelta, "len", aveLen, "#extract calls", ret.count)
    x.append("Ave delta: \(aveDelta)\n")
    x.append("Ave len: \(aveLen)\n")
    try? x.write(toFile: "/Users/ellieshin/Developer/misc/mockolo/stats-data.txt", atomically: true, encoding: .utf8)
    return ret
}

public func useString(_ mockpaths: [String]) -> [String] {
    var ret = [""]
    var stats = [(0.0, 0)]
    var aveDelta = 0.0
    var aveLen = 0
    for p in mockpaths {
        if let s = try? Structure(path: p),
            let d = try? String(contentsOfFile: p) {
//            for child in s.substructures {
                for sub in s.substructures {
                    let length = Int64(1400) //sub.length
                    let start = CFAbsoluteTimeGetCurrent()
                    let t = d.extractString(offset: sub.offset, length: length)
                    let end = CFAbsoluteTimeGetCurrent()
                    ret.append(t)
                    let delta = end-start
                    let len = Int(length)
                    aveDelta += delta
                    aveLen += len
                    stats.append((delta, len))
                }
            }
//        }
    }
    
    
    print("Total: delta", aveDelta, "len", aveLen, "#extract calls", ret.count)
    var x = stats.sorted {$0.1 < $1.1}.map {"\($0.0); \($0.1)" }.joined(separator: "\n")
    x.append("#extract calls: \(ret.count)\n")
    x.append("Total delta: \(aveDelta)\n")
    x.append("Total len: \(aveLen)\n")
    aveDelta /= Double(ret.count)
    aveLen /= ret.count
    print("Ave: delta", aveDelta, "len", aveLen, "#extract calls", ret.count)
    x.append("Ave delta: \(aveDelta)\n")
    x.append("Ave len: \(aveLen)\n")
    try? x.write(toFile: "/Users/ellieshin/Developer/misc/mockolo/stats-str.txt", atomically: true, encoding: .utf8)
    return ret
}


enum InputError: Error {
    case annotationError
    case sourceFilesError
}

/// Performs end to end mock generation flow
public func generate(sourceDirs: [String]?,
                     sourceFiles: [String]?,
                     exclusionSuffixes: [String],
                     mockFilePaths: [String]?,
                     annotatedOnly: Bool,
                     annotation: String,
                     header: String?,
                     macro: String?,
                     to outputFilePath: String,
                     loggingLevel: Int,
                     concurrencyLimit: Int?,
                     onCompletion: @escaping (String) -> ()) throws {

    guard let annotationData = annotation.data(using: .utf8) else {
        log("Annotation is invalid", level: .error)
        throw InputError.annotationError
    }

    guard sourceDirs != nil || sourceFiles != nil else {
        log("Source files or directories do not exist", level: .error)
        throw InputError.sourceFilesError
    }

    minLogLevel = loggingLevel
    var candidates = [(String, Int64)]()
    var parentMocks = [String: Entity]()
    var annotatedProtocolMap = [String: Entity]()
    var protocolMap = [String: Entity]()
    var processedImportLines = [String: [String]]()
    var pathToContentMap = [(String, Data, Int64)]()
    var resolvedEntities = [ResolvedEntity]()
    
    let maxConcurrentThreads = concurrencyLimit ?? 0
    let sema = maxConcurrentThreads <= 1 ? nil: DispatchSemaphore(value: maxConcurrentThreads)
    let mockgenQueue = maxConcurrentThreads == 1 ? nil: DispatchQueue(label: "mockgen-q", qos: DispatchQoS.userInteractive, attributes: DispatchQueue.Attributes.concurrent)

    signpost_begin(name: "Process input")
    let t0 = CFAbsoluteTimeGetCurrent()
    log("Process input mock files...", level: .info)
    if let mockFilePaths = mockFilePaths {
        generateProcessedTypeMap(mockFilePaths,
                                 semaphore: sema,
                                 queue: mockgenQueue) { (elements, imports) in
                                    elements.forEach { element in
                                        parentMocks[element.name] = element
                                        if processedImportLines[element.filepath] == nil {
                                            processedImportLines[element.filepath] = imports
                                        }
                                    }
        }
    }
    signpost_end(name: "Process input")
    let t1 = CFAbsoluteTimeGetCurrent()
    log("Took", t1-t0, level: .verbose)

    signpost_begin(name: "Generate protocol map")
    log("Process source files and generate an annotated/protocol map...", level: .info)
    generateProtocolMap(sourceDirs: sourceDirs,
                        sourceFiles: sourceFiles,
                        exclusionSuffixes: exclusionSuffixes,
                        annotatedOnly: annotatedOnly,
                        annotation: annotationData,
                        semaphore: sema,
                        queue: mockgenQueue) { (elements) in
                            elements.forEach { element in
                                protocolMap[element.name] = element
                                if element.isAnnotated {
                                    annotatedProtocolMap[element.name] = element
                                }
                            }
    }
    signpost_end(name: "Generate protocol map")
    let t2 = CFAbsoluteTimeGetCurrent()
    log("Took", t2-t1, level: .verbose)

    signpost_begin(name: "Generate models")
    let typeKeyList = [parentMocks.compactMap {$0.key.components(separatedBy: "Mock").first}, annotatedProtocolMap.map {$0.key}].flatMap{$0}
    var typeKeys = [String: String]()
    typeKeyList.forEach { (t: String) in
        typeKeys[t] = "\(t)Mock()"
    }
    
    log("Resolve inheritance and generate unique entity models...", level: .info)
    
    generateUniqueModels(protocolMap: protocolMap,
                         annotatedProtocolMap: annotatedProtocolMap,
                         inheritanceMap: parentMocks,
                         typeKeys: typeKeys,
                         semaphore: sema,
                         queue: mockgenQueue,
                         process: { (entity, pathsToContents) in
                            pathToContentMap.append(contentsOf: pathsToContents)
                            resolvedEntities.append(entity)
    })
    signpost_end(name: "Generate models")
    let t3 = CFAbsoluteTimeGetCurrent()
    log("Took", t3-t2, level: .verbose)

    signpost_begin(name: "Render models")
    log("Render models with templates...", level: .info)
    renderTemplates(entities: resolvedEntities,
                    typeKeys: typeKeys,
                    semaphore: sema,
                    queue: mockgenQueue,
                    process: { (mockString: String, offset: Int64) in
                        candidates.append((mockString, offset))
    })
    signpost_end(name: "Render models")
    let t4 = CFAbsoluteTimeGetCurrent()
    log("Took", t4-t3, level: .verbose)

    signpost_begin(name: "Write results")
    log("Write the mock results and import lines to", outputFilePath, level: .info)
    let result = write(candidates: candidates,
                       processedImportLines: processedImportLines,
                       pathToContentMap: pathToContentMap,
                       header: header,
                       macro: macro,
                       to: outputFilePath)
    signpost_end(name: "Write results")
    let t5 = CFAbsoluteTimeGetCurrent()
    log("Took", t5-t4, level: .verbose)
    
    let count = result.components(separatedBy: "\n").count
    log("TOTAL", t5-t0, level: .verbose)
    log("#Protocols = \(protocolMap.count), #Annotated protocols = \(annotatedProtocolMap.count), #Parent mock classes = \(parentMocks.count), #Final mock classes = \(candidates.count), File LoC = \(count)", level: .verbose)
    
    onCompletion(result)
}
