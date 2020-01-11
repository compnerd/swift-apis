// Copyright 2019 The TensorFlow Authors. All Rights Reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
import Darwin
#elseif os(Windows)
import ucrt
#else
import Glibc
#endif

// A thread that runs the provided body.
class Thread {
    class Procedure {
        let body: () -> ()

        init(_ body: @escaping () -> ()) {
            self.body = body
        }

        func run() {
            self.body()
        }
    }

    var thread: pthread_t

    init(perform body: @escaping () -> ()) {
        let context = Unmanaged.passRetained(Procedure(body)).toOpaque()
        let status = pthread_create(&self.thread, nil, {
            // Set the cancelability of the detached thread.
            pthread_setcanceltype(Int32(PTHREAD_CANCEL_DEFERRED), nil)

            let procedure: Thread.Procedure =
                Unmanaged.fromOpaque($0).takeRetainedValue()
            procedure.run()
            return nil
        }, context)
        internalConsistencyCheck(status == 0)
    }

    func join() {
        internalConsistencyCheck(pthread_join(thread, nil) == 0)
    }
}

public func _runOnNDevices(_ n: Int, perform body: @escaping (Int) -> ()) {
    var threads = [] as [Thread]
    for i in 0..<n {
        threads.append(Thread {
            body(i)
        })
    }
    for t in threads {
        t.join()
    }
}
