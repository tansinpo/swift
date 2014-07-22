// RUN: %swift -parse -verify %s

class C {}
class D {}

func takesMutablePointer(x: UnsafeMutablePointer<Int>) {} // expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}
func takesMutableVoidPointer(x: UnsafeMutablePointer<Void>) {}  // expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}
func takesMutableInt8Pointer(x: UnsafeMutablePointer<Int8>) {}  // expected-note{{}}expected-note{{}}
func takesMutableArrayPointer(x: UnsafeMutablePointer<[Int]>) {} // expected-note{{}}
func takesConstPointer(x: UnsafePointer<Int>) -> Character { return "x" } // expected-note{{}}expected-note{{}}expected-note{{}}
func takesConstInt8Pointer(x: UnsafePointer<Int8>) {}
func takesConstUInt8Pointer(x: UnsafePointer<UInt8>) {}
func takesConstVoidPointer(x: UnsafePointer<Void>) {}
func takesAutoreleasingPointer(x: AutoreleasingUnsafeMutablePointer<C>) {} // expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}expected-note{{}}

func mutablePointerArguments(p: UnsafeMutablePointer<Int>,
                             cp: UnsafePointer<Int>,
                             ap: AutoreleasingUnsafeMutablePointer<Int>) {
  takesMutablePointer(nil)
  takesMutablePointer(p)
  takesMutablePointer(cp) // expected-error{{}}
  takesMutablePointer(ap) // expected-error{{}}
  var i: Int = 0
  var f: Float = 0
  takesMutablePointer(&i)
  takesMutablePointer(&f) // expected-error{{}}
  takesMutablePointer(i) // expected-error{{}}
  takesMutablePointer(f) // expected-error{{}}
  var ii: [Int] = [0, 1, 2]
  var ff: [Float] = [0, 1, 2]
  takesMutablePointer(&ii)
  takesMutablePointer(&ff) // expected-error{{}}
  takesMutablePointer(ii) // expected-error{{}}
  takesMutablePointer(ff) // expected-error{{}}

  takesMutableArrayPointer(&i) // expected-error{{}}
  takesMutableArrayPointer(&ii)

  // We don't allow these conversions outside of function arguments.
  var x: UnsafeMutablePointer<Int> = &i // expected-error{{}}
  x = &ii // expected-error{{}}
}

func mutableVoidPointerArguments(p: UnsafeMutablePointer<Int>,
                                 cp: UnsafePointer<Int>,
                                 ap: AutoreleasingUnsafeMutablePointer<Int>,
                                 fp: UnsafeMutablePointer<Float>) {
  takesMutableVoidPointer(nil)
  takesMutableVoidPointer(p)
  takesMutableVoidPointer(fp)
  takesMutableVoidPointer(cp) // expected-error{{}}
  takesMutableVoidPointer(ap) // expected-error{{}}
  var i: Int = 0
  var f: Float = 0
  takesMutableVoidPointer(&i)
  takesMutableVoidPointer(&f)
  takesMutableVoidPointer(i) // expected-error{{}}
  takesMutableVoidPointer(f) // expected-error{{}}
  var ii: [Int] = [0, 1, 2]
  var dd: [CInt] = [1, 2, 3]
  var ff: [Int] = [0, 1, 2]
  takesMutableVoidPointer(&ii)
  takesMutableVoidPointer(&dd)
  takesMutableVoidPointer(&ff)
  takesMutableVoidPointer(ii) // expected-error{{}}
  takesMutableVoidPointer(ff) // expected-error{{}}

  // We don't allow these conversions outside of function arguments.
  var x: UnsafeMutablePointer<Void> = &i // expected-error{{}}
  x = p // expected-error{{}}
  x = &ii // expected-error{{}}
}

func constPointerArguments(p: UnsafeMutablePointer<Int>,
                           cp: UnsafePointer<Int>,
                           ap: AutoreleasingUnsafeMutablePointer<Int>) {
  takesConstPointer(nil)
  takesConstPointer(p)
  takesConstPointer(cp)
  takesConstPointer(ap)

  var i: Int = 0
  var f: Float = 0
  takesConstPointer(&i)
  takesConstPointer(&f) // expected-error{{}}
  var ii: [Int] = [0, 1, 2]
  var ff: [Float] = [0, 1, 2]
  takesConstPointer(&ii)
  takesConstPointer(&ff) // expected-error{{}}
  takesConstPointer(ii)
  takesConstPointer(ff) // expected-error{{}}
  takesConstPointer([0, 1, 2])
  takesConstPointer([0.0, 1.0, 2.0]) // expected-error{{}}

  // We don't allow these conversions outside of function arguments.
  var x: UnsafePointer<Int> = &i // expected-error{{}}
  x = ii // expected-error{{}}
  x = p // expected-error{{}}
  x = ap // expected-error{{}}
}

func constVoidPointerArguments(p: UnsafeMutablePointer<Int>,
                               fp: UnsafeMutablePointer<Float>,
                               cp: UnsafePointer<Int>,
                               cfp: UnsafePointer<Float>,
                               ap: AutoreleasingUnsafeMutablePointer<Int>,
                               afp: AutoreleasingUnsafeMutablePointer<Float>) {
  takesConstVoidPointer(nil)
  takesConstVoidPointer(p)
  takesConstVoidPointer(fp)
  takesConstVoidPointer(cp)
  takesConstVoidPointer(cfp)
  takesConstVoidPointer(ap)
  takesConstVoidPointer(afp)

  var i: Int = 0
  var f: Float = 0
  takesConstVoidPointer(&i)
  takesConstVoidPointer(&f)
  var ii: [Int] = [0, 1, 2]
  var ff: [Float] = [0, 1, 2]
  takesConstVoidPointer(&ii)
  takesConstVoidPointer(&ff)
  takesConstVoidPointer(ii)
  takesConstVoidPointer(ff)
  // TODO: takesConstVoidPointer([0, 1, 2])
  // TODO: takesConstVoidPointer([0.0, 1.0, 2.0])

  // We don't allow these conversions outside of function arguments.
  var x: UnsafePointer<Void> = &i // expected-error{{}}
  x = ii // expected-error{{}}
  x = p // expected-error{{}}
  x = fp // expected-error{{}}
  x = cp // expected-error{{}}
  x = cfp // expected-error{{}}
  x = ap // expected-error{{}}
  x = afp // expected-error{{}}
}

func stringArguments(var s: String) {
  takesConstVoidPointer(s)
  takesConstInt8Pointer(s)
  takesConstUInt8Pointer(s)
  takesConstPointer(s) // expected-error{{}}

  takesMutableVoidPointer(s) // expected-error{{}}
  takesMutableInt8Pointer(s) // expected-error{{}}
  takesMutableInt8Pointer(&s) // expected-error{{}}
  takesMutablePointer(s) // expected-error{{}}
  takesMutablePointer(&s) // expected-error{{}}
}

func autoreleasingPointerArguments(p: UnsafeMutablePointer<Int>,
                                   cp: UnsafePointer<Int>,
                                   ap: AutoreleasingUnsafeMutablePointer<C>) {
  takesAutoreleasingPointer(nil)
  takesAutoreleasingPointer(p) // expected-error{{}}
  takesAutoreleasingPointer(cp) // expected-error{{}}
  takesAutoreleasingPointer(ap)

  var c: C = C()
  takesAutoreleasingPointer(&c)
  takesAutoreleasingPointer(c) // expected-error{{}}
  var d: D = D()
  takesAutoreleasingPointer(&d) // expected-error{{}}
  takesAutoreleasingPointer(d) // expected-error{{}}
  var cc: [C] = [C(), C()]
  var dd: [D] = [D(), D()]
  takesAutoreleasingPointer(&cc) // expected-error{{}}
  takesAutoreleasingPointer(&dd) // expected-error{{}}

  var x: AutoreleasingUnsafeMutablePointer<C> = &c // expected-error{{}}
}

func pointerConstructor(x: UnsafeMutablePointer<Int>) -> UnsafeMutablePointer<Float> {
  return UnsafeMutablePointer(x)
}

func pointerArithmetic(x: UnsafeMutablePointer<Int>, y: UnsafeMutablePointer<Int>,
                       i: Int) {
  let p = x + i
  let d = x - y
}

func genericPointerArithmetic<T>(x: UnsafeMutablePointer<T>, i: Int, t: T) -> UnsafeMutablePointer<T> {
  let p = x + i
  p.initialize(t)
}

func passPointerToClosure(f: UnsafeMutablePointer<Float> -> Int) -> Int { }

func pointerInClosure(f: UnsafeMutablePointer<Int> -> Int) -> Int {
  return passPointerToClosure { f(UnsafeMutablePointer($0)) }
}

struct NotEquatable {}

func arrayComparison(x: [NotEquatable], y: [NotEquatable], p: UnsafeMutablePointer<NotEquatable>) {
  // Don't allow implicit array-to-pointer conversions in operators.
  let a: Bool = x == y // expected-error{{}}
  // FIXME: Should be allowed.
  // let b: Bool = p == &x
}

func addressConversion(p: UnsafeMutablePointer<Int>, var x: Int) {
  let a: Bool = p == &x
}
