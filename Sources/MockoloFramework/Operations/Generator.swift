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

enum InputError: Error {
    case annotationError
    case sourceFilesError
}

/// Performs end to end mock generation flow
public func generate(sourceDirs: [String]?,
                     sourceFiles: [String]?,
                     exclusionSuffixes: [String],
                     mockFilePaths: [String]?,
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
