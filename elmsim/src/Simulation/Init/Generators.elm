module Simulation.Init.Generators exposing (..)

import Action exposing (Msg(..))
import Array
import Graph exposing (NodeId)
import Random exposing (Generator)
import Random.Extra as Random
import Simulation.GraphUpdates exposing (createEdge)
import Simulation.Model exposing (..)
import Simulation.NodeList as NodeList
import Simulation.WeatherList exposing (restWeather, weatherTupleToWeather)


coordsGenerator : Random.Generator Coords
coordsGenerator =
    let
        coordsFunc =
            (Array.fromList NodeList.peerList
                |> flip Array.get
            )
                >> Maybe.map NodeList.tupleToCoords
                >> Maybe.withDefault (Coords 0 0)

        coordsLimit =
            List.length NodeList.peerList - 1
    in
    Random.map coordsFunc
        (Random.int 0 coordsLimit)



--generateWeather : List WeatherTuple -> Cmd Msg
--generateWeather list =
--    Random.map2 Weather
--        (Random.float 0 1)
--        (Random.float 0 1)
--        |> Random.generate UpdateWeather


generatePVPanel : Cmd Msg
generatePVPanel =
    Random.map4 SimGenerator
        (Random.constant [])
        -- dailyConsumption
        (Random.float 0 10)
        -- maxGeneration
        coordsGenerator
        -- xy coordinates
        (Random.constant SolarPanel)
        -- generator type
        |> Random.generate AddGenerator


generateWindTurbine : Cmd Msg
generateWindTurbine =
    Random.map4 SimGenerator
        (Random.constant [])
        (Random.float 0 10)
        -- capacity
        coordsGenerator
        (Random.constant WindTurbine)
        |> Random.generate AddGenerator



--generatePeerJoules : PeerJoules
--generatePeerJoules =
--    Random.map4 PeerJoules
--        -- stored
--        (Random.constant [0])
--        -- actual consumption
--        (Random.constant [0])
--        -- desired consumption
--        (Random.float 7 10)
--        -- seedRating in joules?
--        (Random.constant [0])
--        |> Random.generate


generatePeer : Cmd Msg
generatePeer =
    Random.map4 Peer
        --        generatePeerJoules
        (Random.map5 PeerJoules
            (Random.constant [ 0 ])
            -- actual consumption
            (Random.constant [ 0 ])
            -- desired consumption
            (Random.float 5 10)
            -- seedRating in joules?
            (Random.constant [ 0 ])
            -- initial trade balance
            (Random.constant [ 0 ])
        )
        -- negawatts
        (Random.constant [ 0 ])
        -- initial reputation
        (Random.constant [ 1 ])
        coordsGenerator
        |> Random.generate AddPeer


generateEdge : Cmd Msg
generateEdge =
    Random.map2 createEdge
        --        (Random.int 0 45)
        --        (Random.int 0 45)
        (Random.int 0 10)
        (Random.int 0 10)
        |> Random.generate AddEdge
