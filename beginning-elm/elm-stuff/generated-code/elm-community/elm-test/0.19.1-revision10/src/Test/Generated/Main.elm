module Test.Generated.Main exposing (main)

import FuzzTests

import Test.Reporter.Reporter exposing (Report(..))
import Console.Text exposing (UseColor(..))
import Test.Runner.Node
import Test

main : Test.Runner.Node.TestProgram
main =
    Test.Runner.Node.run
        { runs = 100
        , report = ConsoleReport UseColor
        , seed = 343049195341942
        , processes = 8
        , globs =
            [ "tests/FuzzTests.elm"
            ]
        , paths =
            [ "/Users/kkaminky/Tutorials/BeginningElm/beginning-elm/tests/FuzzTests.elm"
            ]
        }
        [ ( "FuzzTests"
          , [ Test.Runner.Node.check FuzzTests.addOneTests
            , Test.Runner.Node.check FuzzTests.addTests
            , Test.Runner.Node.check FuzzTests.flipTests
            , Test.Runner.Node.check FuzzTests.listLengthTests
            , Test.Runner.Node.check FuzzTests.multiplyFloatTests
            , Test.Runner.Node.check FuzzTests.pizzaLeftTests
            , Test.Runner.Node.check FuzzTests.stringTests
            ]
          )
        ]