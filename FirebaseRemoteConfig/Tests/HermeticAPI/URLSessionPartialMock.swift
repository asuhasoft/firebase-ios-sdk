// Copyright 2020 Google LLC
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation

// Create a partial mock by subclassing the URLSessionDataTask.
class URLSessionDataTaskMock: URLSessionDataTask {
  private let closure: () -> Void

  init(closure: @escaping () -> Void) {
    self.closure = closure
  }

  override func resume() {
    closure()
  }
}

class URLSessionMock: URLSession {
  typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

  // Properties to control what gets returned to the URLSession callback.
  // error could also be added here.
  var data: Data?
  var response: URLResponse?
  var etag = ""

  override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
    let consoleValues = FakeConsole.get() as Dictionary
//    if etag == "" || consoleValues["state"] == "UPDATE" {
//
//    }
    let jsonData = try! JSONSerialization.data(withJSONObject: consoleValues)
    let response = HTTPURLResponse.init(url: URL.init(fileURLWithPath: "fakeURL"), statusCode: 200, httpVersion: nil, headerFields: nil)
    return URLSessionDataTaskMock {
      completionHandler(jsonData, response, nil)
    }
  }
}