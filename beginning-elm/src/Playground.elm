module Playground exposing
    ( Character
    , Greeting(..)
    , add
    , arya
    , descending
    , doubleScores
    , escapeEarth
    , getAdultAge
    , guardiansWithShortNames
    , highestScores
    , main
    , sansa
    , sayHello
    , scoresLessThan320
    , signUp
    , validateEmail
    )

import Html exposing (Html, a, text)
import MyList exposing (..)
import Regex


escapeEarth : Float -> Float -> String -> String
escapeEarth myVelocity mySpeed fuelStatus =
    let
        escapeVelocityInKmPerSec =
            11.186

        orbitalSpeedInKmPerSec =
            7.67

        whereToLand =
            if fuelStatus == "low" then
                "Land on droneship"

            else
                "Land on launchpad"
    in
    if myVelocity > escapeVelocityInKmPerSec then
        "Godspeed"

    else if mySpeed == orbitalSpeedInKmPerSec then
        "Stay in orbit"

    else
        whereToLand


computeSpeed : Float -> Float -> Float
computeSpeed distance time =
    distance / time


computeTime : Float -> Float -> Float
computeTime startTime endTime =
    endTime - startTime


weekday : Int -> String
weekday dayInNumber =
    case dayInNumber of
        0 ->
            "Sunday"

        1 ->
            "Monday"

        2 ->
            "Tuesday"

        3 ->
            "Wednesday"

        4 ->
            "Thursday"

        5 ->
            "Friday"

        6 ->
            "Saturday"

        7 ->
            "Sunday"

        _ ->
            "Unknown Day"


hashtag : String -> String
hashtag dayInNumber =
    case dayInNumber of
        "Sunday" ->
            "Church"

        "Monday" ->
            "MondayBlues"

        "Tuesday" ->
            "TakeMeBackTuesday"

        "Wednesday" ->
            "#Humpday"

        "Thursday" ->
            "ThrowbackThursday"

        "Friday" ->
            "#FlashbackFriday"

        "Saturday" ->
            "#Caturday"

        _ ->
            "#Whatever"


multiply : number -> number -> number
multiply c d =
    c * d


divide : Float -> Float -> Float
divide e f =
    e / f


revelation =
    """
    It became very clear to me sitting out there today
    that every decision I've made in my entire life has
    been wrong. My life is the complete "opposite" of
    everything I want it to be. Every instinct I have,
    in every aspect of life, be it something to wear,
    something to eat - it's all been wrong.
    """


descending : comparable -> comparable -> Order
descending a b =
    case compare a b of
        LT ->
            GT

        GT ->
            LT

        EQ ->
            EQ


evilometer : String -> String -> Order
evilometer character1 character2 =
    case ( character1, character2 ) of
        ( "Joffrey", "Ramsay" ) ->
            LT

        ( "Joffrey", "Night King" ) ->
            LT

        ( "Ramsay", "Joffrey" ) ->
            GT

        ( "Ramsay", "Night King" ) ->
            LT

        ( "Night King", "Joffrey" ) ->
            GT

        ( "Night King", "Ramsay" ) ->
            GT

        _ ->
            GT


validateEmail : String -> ( String, String )
validateEmail email =
    let
        emailPattern =
            "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b"

        regex =
            Maybe.withDefault Regex.never <|
                Regex.fromString emailPattern

        isValid =
            Regex.contains regex email
    in
    if isValid then
        ( "Valid email", "green" )

    else
        ( "Invalid email", "red" )


outerMultiplier : number
outerMultiplier =
    6


multiplyByFive : number -> number
multiplyByFive number =
    let
        multiplier =
            5
    in
    number * multiplier


scoreMultiplier : number
scoreMultiplier =
    2


highestScores =
    [ 316, 320, 312, 370, 337, 318, 314 ]


doubleScores : List number -> List number
doubleScores scores =
    List.map (\x -> x * scoreMultiplier) scores


scoresLessThan320 : List number -> List number
scoresLessThan320 scores =
    List.filter isLessThan320 scores


isLessThan320 : number -> Bool
isLessThan320 score =
    score < 320


addOne : number -> number
addOne y =
    y + 1


guardiansWithShortNames : List String -> Int
guardiansWithShortNames guardians =
    guardians
        |> List.map String.length
        |> List.filter (\x -> x < 6)
        |> List.length


add : number -> number -> number
add num1 num2 =
    num1 + num2


type Greeting
    = Howdy
    | Hola
    | Namaste String
    | NumericalHi Int Int


sayHello : Greeting -> String
sayHello greeting =
    case greeting of
        Howdy ->
            "How y'all doin'?"

        Hola ->
            "Hola amigo!"

        Namaste message ->
            message

        NumericalHi value1 value2 ->
            value1 + value2 |> String.fromInt


signUp : String -> String -> Result String String
signUp email ageStr =
    case String.toInt ageStr of
        Nothing ->
            Err "Age must be an integer."

        Just age ->
            let
                emailPattern =
                    "\\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}\\b"

                regex =
                    Maybe.withDefault Regex.never <|
                        Regex.fromString emailPattern

                isValidEmail =
                    Regex.contains regex email
            in
            if age < 13 then
                Err "You need to be at least 13 years old to sign up."

            else if isValidEmail then
                Ok "Your account has been created successfully!"

            else
                Err "You entered an invalid email."


type alias Character =
    { name : String
    , age : Maybe Int
    }


sansa : Character
sansa =
    { name = "Sansa"
    , age = Just 19
    }


arya : Character
arya =
    { name = "Arya"
    , age = Nothing
    }


getAdultAge : Character -> Maybe Int
getAdultAge character =
    case character.age of
        Nothing ->
            Nothing

        Just age ->
            if age >= 18 then
                Just age

            else
                Nothing


list1 : MyList a
list1 =
    Empty


list2 : MyList number
list2 =
    Node 9 Empty


list3 : List a
list3 =
    []


main : Html msg
main =
    isEmpty list2
        |> Debug.toString
        |> text
