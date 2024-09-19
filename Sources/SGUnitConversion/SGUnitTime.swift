// -----------------------------------------------------------------------------
// SGUnitTime.swift
//
// This Swift source file is part of the SGUnitConversion package 
// by Paul C. L. Willmott.
//
// Copyright © 2024 Paul C. L. Willmott. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the “Software”), to deal 
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in 
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR 
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE 
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE 
// SOFTWARE.
// -----------------------------------------------------------------------------
//
// Revision History:
//
//     19/09/2024  Paul Willmott - SGUnitTime.swift created
// -----------------------------------------------------------------------------

import Foundation
import AppKit

public enum SGUnitTime : UInt8, CaseIterable, Sendable {
  
  // MARK: Enumeration
  
  case milliseconds = 0
  case seconds      = 1
  case hours        = 2

  // MARK: Public Properties
  
  public var title : String {
    
    return SGUnitTime.titles[self]!
  }

  public var symbol : String {

    return SGUnitTime.symbols[self]!
  }

  // MARK: Private Class Properties
  
  private static let titles : [SGUnitTime:String] = [
    .milliseconds : String(localized: "Milliseconds"),
    .seconds      : String(localized: "Seconds"),
    .hours        : String(localized: "Hours"),
  ]

  private static let symbols : [SGUnitTime:String] = [
    .milliseconds : String(localized: "ms", comment: "Used for the abbreviation of milliseconds"),
    .seconds      : String(localized: "s", comment: "Used for the abbreviation of seconds"),
    .hours        : String(localized: "h", comment: "Used for the abbreviation of hours"),
  ]


  private static var map : String {
    
    var map = "<map>\n"

    for item in SGUnitTime.allCases {
      map += "<relation><property>\(item.rawValue)</property><value>\(item.title)</value></relation>\n"
    }

    map += "</map>\n"
    
    return map
    
  }
  // MARK: Public Class Properties
  
  public static let mapPlaceholder = "%%UNIT_TIME%%"

  // MARK: Public Class Methods
  
  // The factor to be applied to a time in units to get a time in seconds.
  public static func toS(units: SGUnitTime) -> Double {
    
    switch units {
    case .milliseconds:
      return 0.001
    case .seconds:
      return 1.0
    case .hours:
      return 3600.0
    }
    
  }
  
  // The factor to be applied to a time in seconds to get a time in units.
  public static func fromS(units: SGUnitTime) -> Double {
    return 1.0 / toS(units: units)
  }
  
  public static func convert(fromValue:Double, fromUnits:SGUnitTime, toUnits:SGUnitTime) -> Double {
    return fromValue * toS(units: fromUnits) * fromS(units: toUnits)
  }

  public static func insertMap(cdi:String) -> String {
    return cdi.replacingOccurrences(of: mapPlaceholder, with: map)
  }

}
